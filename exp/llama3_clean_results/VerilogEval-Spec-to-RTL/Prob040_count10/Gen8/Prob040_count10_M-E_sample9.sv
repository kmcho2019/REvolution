module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [9:0] state; // One-hot encoding for states 0 to 9

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state 0
    end else begin
        case (state)
            1'b1: state <= 1'b10; // Transition from state 0 to state 1
            1'b10: state <= 1'b100; // Transition from state 1 to state 2
            1'b100: state <= 1'b1000; // Transition from state 2 to state 3
            1'b1000: state <= 1'b10000; // Transition from state 3 to state 4
            1'b10000: state <= 1'b100000; // Transition from state 4 to state 5
            1'b100000: state <= 1'b1000000; // Transition from state 5 to state 6
            1'b1000000: state <= 1'b10000000; // Transition from state 6 to state 7
            1'b10000000: state <= 1'b100000000; // Transition from state 7 to state 8
            1'b100000000: state <= 1'b1000000000; // Transition from state 8 to state 9
            1'b1000000000: state <= 1'b1; // Transition from state 9 back to state 0
            default: state <= 1'b1; // Default to state 0
        endcase
    end
end

assign q = {state[9], state[8], state[7], state[6]}; // Extract the 4 least significant bits

endmodule