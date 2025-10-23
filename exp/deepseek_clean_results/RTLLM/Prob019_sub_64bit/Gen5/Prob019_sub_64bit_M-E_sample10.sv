module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

wire [63:0] B_comp = ~B + 1'b1; // Two's complement of B
wire [31:0] sum_low, sum_high0, sum_high1;
wire carry_out;

// Lower 32-bit addition (always performed)
assign {carry_out, sum_low} = A[31:0] + B_comp[31:0];

// Carry-select for upper 32 bits
assign sum_high0 = A[63:32] + B_comp[63:32];          // Carry=0 case
assign sum_high1 = A[63:32] + B_comp[63:32] + 1'b1;   // Carry=1 case
assign result = {carry_out ? sum_high1 : sum_high0, sum_low};

// Early overflow prediction logic
wire signs_differ = A[63] ^ B[63];
wire potential_overflow = signs_differ & (A[63] ^ result[63]);

// Final overflow determination
assign overflow = potential_overflow & 
                 ((A[63] & ~B[63] & ~result[63]) |  // Negative overflow
                  (~A[63] & B[63] & result[63]));   // Positive overflow

endmodule