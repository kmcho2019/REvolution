module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

// Calculate integer part width
localparam integer INT_WIDTH = N - Q;

// Internal wires and registers
wire [INT_WIDTH-1:0] int_a, int_b; // Integer parts of inputs
wire [Q-1:0] frac_a, frac_b; // Fractional parts of inputs
wire [INT_WIDTH-1:0] int_res; // Result of integer part addition
wire [Q-1:0] frac_res; // Result of fractional part addition
reg [N-1:0] final_res; // Final result before overflow handling

// Separate integer and fractional parts
assign int_a = a[N-1:Q];
assign int_b = b[N-1:Q];
assign frac_a = a[Q-1:0];
assign frac_b = b[Q-1:0];

// Perform integer part addition
assign int_res = (a[N-1] == b[N-1]) ? (int_a + int_b) : (a[N-1] == 1'b1) ? (int_b - int_a) : (int_a - int_b);

// Perform fractional part addition
assign frac_res = (a[N-1] == b[N-1]) ? (frac_a + frac_b) : (a[N-1] == 1'b1) ? (frac_b - frac_a) : (frac_a - frac_b);

// Combine integer and fractional parts
assign final_res = {int_res, frac_res};

always @(*) begin
    // Apply sign bit based on input operands
    if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin // Both negative
        c = -final_res;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin // Both positive
        c = final_res;
    end else begin // Different signs
        c = final_res;
    end

    // Handle overflow
    if (c[N-1] != c[N-2]) begin // Overflow detected
        c = {1'b1, {N-1{1'b0}}}; // Set to maximum negative value for N bits
    end
end

endmodule