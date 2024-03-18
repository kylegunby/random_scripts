'''
[WIP]
Base64 Encoder


'''

from sys import argv


def get_binary_string(string):
    return ''.join('{0:08b}'.format(ord(x), 'b') for x in string)

def create_binary_array(b_str):
    arr = []
    current = ''
    for i in range(0, len(b_str)):
        if i == (len(b_str) - 1):
            if i % 6 == 0:
                arr.append(current)
                arr.append(b_str[i])
            else:
                current += b_str[i]
                arr.append(current)
        
            break
        
        
        if i != 0 and i % 6 == 0:
            arr.append(current)
            current = b_str[i]
        else:
            current += b_str[i]
        
    return arr



if __name__ == '__main__':
    default_string = 'Kyle'
    string = argv[1] if len(argv) > 1 else default_string

    binary_string = get_binary_string(string)
    binary_array = create_binary_array(binary_string)

    print(binary_array)





