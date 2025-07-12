module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out = {
        in[9:0],    in[19:10],  in[29:20],  in[39:30],  in[49:40],
        in[59:50],  in[69:60],  in[79:70],  in[89:80],  in[99:90]
    };

endmodule