import torch.nn as nn 

class EMAhelper(object):
    def __init__(self, mu):
        self.mu = mu 
        self.shadow = {}

    def register(self, module):
        if isinstance(module, nn.DataParallel):
            module = module.module
        for name, param in module.named_parameters():
            if param.requires_grad:
                self.shadow[name] = param.data.clone()

    def update(self, module):
        if isinstance(module, nn.DataParallel):
            module = module.module
        for name, param in module.named_parameters():
            if param.requires_grad:
                self.shadow[name] = (1.0 - self.mu) * param.data + self.mu * self.shadow[name].clone()