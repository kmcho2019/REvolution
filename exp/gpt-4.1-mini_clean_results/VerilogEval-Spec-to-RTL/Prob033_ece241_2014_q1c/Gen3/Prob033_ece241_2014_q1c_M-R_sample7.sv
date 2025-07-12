module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output        overflow
);

    reg [7:0] sum;

    // Compute sum in combinational always block
    always @(*) begin
        sum = a + b;
        s = sum;
    end

    // Overflow detection: sign bits of a and b are same but differ from sum's sign bit
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule