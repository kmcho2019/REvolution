module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Define states
enum logic [1:0] { RESET, ACCUMULATE } state, next_state;

// Accumulator Register
reg [31:0] c_reg;

// Next state logic
always_comb begin
    case (state)
        RESET: next_state = (rst) ? RESET : ACCUMULATE;
        ACCUMULATE: next_state = (rst) ? RESET : ACCUMULATE;
        default: next_state = RESET;
    endcase
end

// State register
always_ff @(posedge clk) begin
    state <= next_state;
end

// Multiplication and Accumulation
wire [31:0] mult;
assign mult = a * b;

// Accumulator update
always_ff @(posedge clk) begin
    case (state)
        RESET: c_reg <= 32'd0;
        ACCUMULATE: c_reg <= (rst) ? 32'd0 : c_reg + mult;
        default: c_reg <= 32'd0;
    endcase
end

// Output Assignment
assign c = c_reg;

endmodule