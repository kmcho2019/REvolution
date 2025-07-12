module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire [2:0] sum;
    assign sum = {1'b0, in[2]} + {1'b0, in[1]} + {1'b0, in[0]};
    assign out = sum[1:0];
endmodule