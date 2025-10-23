module TopModule (
    input [2:0] in,
    output [1:0] out
);
    wire [1:0] partial_sum;
    
    assign partial_sum = in[0] + in[1];
    assign out = partial_sum + in[2];
endmodule