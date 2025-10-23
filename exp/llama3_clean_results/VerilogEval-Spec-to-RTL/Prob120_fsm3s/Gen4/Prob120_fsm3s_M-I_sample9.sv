`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Use one-hot encoding for states to potentially reduce switching activity
reg [3:0] state, next_state;

initial state = 4'b0001; // Initialize state to A (one-hot encoding)

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (1'b1) // Use one-hot encoding to simplify the case statement
        state[0]: begin next_state = in ? 4'b0010 : 4'b0001; out = 0; end // State A
        state[1]: begin next_state = in ? 4'b0010 : 4'b0100; out = 0; end // State B
        state[2]: begin next_state = in ? 4'b1000 : 4'b0001; out = 0; end // State C
        state[3]: begin next_state = in ? 4'b0010 : 4'b0100; out = 1; end // State D
    endcase
end

endmodule