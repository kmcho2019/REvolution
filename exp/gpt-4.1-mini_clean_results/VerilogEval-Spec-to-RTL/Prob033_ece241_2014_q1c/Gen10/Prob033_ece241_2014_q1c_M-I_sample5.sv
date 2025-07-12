module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output reg       overflow
);
    reg [8:0] sum_ext;

    always @(*) begin
        sum_ext = {1'b0, a} + {1'b0, b};
        s = sum_ext[7:0];
        // Overflow for two's complement addition occurs when the carry into MSB differs from carry out MSB
        // or equivalently when signs of inputs are same but differ from output sign
        overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);
    end
endmodule