module LFSR (
    input clk,
    input rst,
    input load,          // Parallel load enable
    input [3:0] seed,    // Initial seed value
    output reg [3:0] out // Current state
);

parameter POLY = 4'b1100; // Default polynomial: x^4 + x^3 + 1

reg [3:0] next_state;
wire feedback;
reg clk_en;
reg [1:0] clk_div;

// Pseudo-random clock gating
always @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_div <= 2'b00;
        clk_en <= 1'b1;
    end else begin
        clk_div <= clk_div + 1;
        clk_en <= (clk_div == 2'b11); // Enable every 4th cycle
    end
end

// Galois LFSR implementation
assign feedback = out[3];

always @(*) begin
    if (load) begin
        next_state = seed;
    end else if (clk_en) begin
        next_state = {out[2:0], 1'b0} ^ (POLY & {4{feedback}});
    end else begin
        next_state = out;
    end
end

// Non-linear output transformation
wire [3:0] gray_out;
assign gray_out = out ^ (out >> 1); // Convert to Gray code

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001;
    end else begin
        out <= next_state;
    end
end

endmodule