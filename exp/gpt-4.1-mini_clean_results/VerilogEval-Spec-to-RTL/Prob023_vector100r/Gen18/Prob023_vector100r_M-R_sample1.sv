module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    assign out = {
        in[9:0][::-1],
        in[19:10][::-1],
        in[29:20][::-1],
        in[39:30][::-1],
        in[49:40][::-1],
        in[59:50][::-1],
        in[69:60][::-1],
        in[79:70][::-1],
        in[89:80][::-1],
        in[99:90][::-1]
    };
endmodule