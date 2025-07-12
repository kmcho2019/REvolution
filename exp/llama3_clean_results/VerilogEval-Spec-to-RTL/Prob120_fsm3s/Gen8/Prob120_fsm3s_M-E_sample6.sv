`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] state;

// Initialize the state to A (1000)
initial state = 4'b1000;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        case (1'b1)
            state[0]: state <= in? 4'b0100 : 4'b1000; // A
            state[1]: state <= in? 4'b0100 : 4'b0010; // B
            state[2]: state <= in? 4'b0001 : 4'b1000; // C
            state[3]: state <= in? 4'b0100 : 4'b0010; // D
            default: state <= 4'b1000; // Default to A
        endcase
    end
end

// Output logic
always @(*) begin
    out = state[3]; // Output is high only in state D
end

endmodule