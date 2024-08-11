 gcc -c sleep.c   => biên dịch
 gcc -shared -o mylib.so.1.0 sleep.o  => định nghĩa thư viện
 export LD_PRELOAD=./mylib.so.1.0 => biến mội trường trỏ đến thư viện ta đã định nghĩa

 để chương trình quay lại thư viện cũ => unset LD_PRELOAD 

 https://github.com/quang-ute?tab=repositories
 https://github.com/quang-ute/Security-labs/blob/main/Software/buffer-overflow/bof1.c