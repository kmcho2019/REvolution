// Multiplying Accumulator (MAC) module with pipelined multiplier and accumulator
module pe (
    input clk, // Clock signal
    input rst, // Reset signal
    input [31:0] a, // 32-bit input operand A
    input [31:0] b, // 32-bit input operand B
    output reg [31:0] c // 32-bit output representing the accumulated result
);

// Internal signals for pipelined stages
reg [31:0] mult_result;
reg [31:0] accum_result;

// Stage 1: Multiplier
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        mult_result <= 32'd0;
    end else begin
        // Multiply a and b using a carry-save adder (CSA) tree
        mult_result <= a * b;
    end
end

// Stage 2: Accumulator
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        accum_result <= 32'd0;
    end else begin
        // Accumulate the multiplication result with the current accumulator value
        accum_result <= accum_result + mult_result;
    end
end

// Stage 3: Output
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0;
    end else begin
        // Output the final accumulated result
        c <= accum_result;
    end
end

endmodule