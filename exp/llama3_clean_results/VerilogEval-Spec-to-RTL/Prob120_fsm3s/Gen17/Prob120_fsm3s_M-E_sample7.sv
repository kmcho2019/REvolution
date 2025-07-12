`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] state; // One-hot encoding for states
reg [3:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (1'b1)
        state[3]: next_state = in ? 4'b0100 : 4'b1000; // From state A
        state[2]: next_state = in ? 4'b0100 : 4'b0010; // From state B
        state[1]: next_state = in ? 4'b0001 : 4'b1000; // From state C
        state[0]: next_state = in ? 4'b0100 : 4'b0010; // From state D
        default: next_state = 4'b1000; // Default to state A if none of the above
    endcase
end

assign out = state[0]; // Output is high only for state D

endmodule