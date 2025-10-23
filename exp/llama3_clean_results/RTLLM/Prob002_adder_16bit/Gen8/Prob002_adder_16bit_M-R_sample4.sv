module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Internal signal for carry
wire [15:0] carry;

// Generate block for bits 0 to 15
genvar i;
generate
    for (i = 0; i < 16; i++) begin
        if (i == 0) begin
            // First bit (bit 0) adder
            assign y[i] = a[i] ^ b[i] ^ Cin;
            assign carry[i] = (a[i] & b[i]) | (a[i] & Cin) | (b[i] & Cin);
        end else begin
            // Bits 1 to 15 adders
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    end
endgenerate

// Assign Co
assign Co = carry[15];

endmodule