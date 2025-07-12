// 16-bit full adder module using ripple carry adder approach
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [15:0] c;

    // Calculate sum (y) signals and carry (c) signals
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    generate
        for (genvar i = 1; i < 16; i++) begin
            assign y[i] = a[i] ^ b[i] ^ c[i-1];
            assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
        end
    endgenerate

    // Assign carry-out (Co)
    assign Co = c[15];

endmodule