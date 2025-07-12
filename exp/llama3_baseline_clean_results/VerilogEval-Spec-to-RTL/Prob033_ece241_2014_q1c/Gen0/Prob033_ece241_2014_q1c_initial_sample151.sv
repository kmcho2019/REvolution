module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

wire [8:0] temp_sum;

assign temp_sum = {1'b0, a} + {1'b0, b};

assign s = temp_sum[7:0];
assign overflow = temp_sum[8] & (a[7] == b[7]) & (a[7] != s[7]) | 
                 ~temp_sum[8] & (a[7] != b[7]) & (a[7] != s[7]);

endmodule