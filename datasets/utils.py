import os
import os.path
import hashlib
import errno
from torch.utils.model_zoo import tqdm


def gen_bar_updater():
    pbar = tqdm(total=None)
    def bar_update(count, block_size, total_size):
        