`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] state; // One-hot encoding for states A, B, C, D

initial state = 4'b1000; // Initialize to state A

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        case (1'b1) // Use one-hot encoding to simplify case statement
            state[0]: state <= in ? 4'b0100 : 4'b1000; // From A
            state[1]: state <= in ? 4'b0100 : 4'b0010; // From B
            state[2]: state <= in ? 4'b0001 : 4'b1000; // From C
            state[3]: state <= in ? 4'b0100 : 4'b0010; // From D
        endcase
    end
end

assign out = state[3]; // Output is '1' only when in state D

endmodule