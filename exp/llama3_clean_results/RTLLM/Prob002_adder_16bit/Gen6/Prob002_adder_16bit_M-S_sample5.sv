module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Internal signal for carry
wire [15:0] carry;

// First bit (bit 0) adder
assign y[0] = a[0] ^ b[0] ^ Cin;
assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

// Bits 1 to 15 adders
genvar i;
generate
    for (i = 1; i < 16; i++) begin
        assign y[i] = a[i] ^ b[i] ^ carry[i-1];
        assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
    end
endgenerate

// Assign Co
assign Co = carry[15];

endmodule