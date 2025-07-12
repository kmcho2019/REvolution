// Define the module for a 16-bit full adder using ripple-carry
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry
    wire [15:0] c;

    // Calculate output and carry
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    generate
        for (genvar i = 1; i < 16; i++) begin
            assign y[i] = a[i] ^ b[i] ^ c[i-1];
            assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
        end
    endgenerate

    assign Co = c[15];

endmodule