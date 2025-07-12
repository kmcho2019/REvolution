module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    input  wire         clk,  // Clock signal
    input  wire         rst_n,  // Reset signal (active low)
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire         overflow  // 1-bit output indicating whether an overflow occurred
);

    reg [63:0] diff;  // Register to store the difference between A and B
    reg [63:0] result_reg;  // Register to store the result
    reg         overflow_reg;  // Register to store the overflow flag

    // Perform binary subtraction of A and B
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            diff <= 64'd0;
        end else begin
            diff <= A - B;
        end
    end

    // Calculate the MSBs of the operands and the result
    wire msb_A = A[63];
    wire msb_B = B[63];
    wire msb_diff = diff[63];

    // Overflow detection logic
    wire overflow_temp = (msb_A == msb_B && msb_A != msb_diff) ? 1'b1 : 1'b0;

    // Register the result and overflow flag
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            result_reg <= 64'd0;
            overflow_reg <= 1'b0;
        end else begin
            result_reg <= diff;
            overflow_reg <= overflow_temp;
        end
    end

    // Assign the result and overflow flag to the output ports
    assign result = result_reg;
    assign overflow = overflow_reg;

endmodule