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
reg [INT_WIDTH-1:0] int_a, int_b; // Integer parts of inputs
reg [Q-1:0] frac_a, frac_b; // Fractional parts of inputs
reg [INT_WIDTH-1:0] int_res; // Result of integer part addition
reg [Q-1:0] frac_res; // Result of fractional part addition
reg [N-1:0] final_res; // Final result before overflow handling

always @(*) begin
    // Separate integer and fractional parts
    int_a = a[N-1:Q];
    int_b = b[N-1:Q];
    frac_a = a[Q-1:0];
    frac_b = b[Q-1:0];

    // Perform integer part addition
    if (a[N-1] == b[N-1]) begin // Same sign
        int_res = int_a + int_b;
    end else begin // Different signs
        if (int_a >= int_b) begin
            int_res = int_a - int_b;
        end else begin
            int_res = int_b - int_a;
        end
    end

    // Perform fractional part addition
    if (a[N-1] == b[N-1]) begin // Same sign
        frac_res = frac_a + frac_b;
    end else begin // Different signs
        if (frac_a >= frac_b) begin
            frac_res = frac_a - frac_b;
        end else begin
            frac_res = frac_b - frac_a;
        end
    end

    // Combine integer and fractional parts
    final_res = {int_res, frac_res};

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