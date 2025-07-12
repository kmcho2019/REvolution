module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state (Gray encoded)
);

reg [3:0] next_state;
reg clk_prev;
wire clk_rise;

// Edge detection for clean clock transitions
assign clk_rise = (clk && !clk_prev);

// Configurable feedback options
wire feedback_option1 = ~(out[3] ^ out[1]);  // Alternate polynomial 1
wire feedback_option2 = ~(out[3] ^ out[2] ^ out[0]);  // Alternate polynomial 2
wire selected_feedback = (out[0]) ? feedback_option1 : feedback_option2;

// Next state computation
always @(*) begin
    next_state[3:1] = out[2:0];  // Standard shift
    next_state[0] = selected_feedback;
end

// Gray code encoder
function [3:0] binary_to_gray;
    input [3:0] binary;
    begin
        binary_to_gray = {binary[3], binary[3]^binary[2], binary[2]^binary[1], binary[1]^binary[0]};
    end
endfunction

always @(posedge clk) begin
    clk_prev <= clk;
    
    if (clk_rise) begin
        if (rst) begin
            // Preserve last state instead of resetting to zero
            out <= binary_to_gray(out);
        end else begin
            out <= binary_to_gray(next_state);
        end
    end
end

endmodule