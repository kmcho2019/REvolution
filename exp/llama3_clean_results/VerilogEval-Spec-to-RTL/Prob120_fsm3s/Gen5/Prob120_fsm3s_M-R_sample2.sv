`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states using one-hot encoding
reg [3:0] state;

// Initialize the state to A (1000)
initial state = 4'b1000;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        case (state)
            4'b1000: state <= in? 4'b0100 : 4'b1000; // A
            4'b0100: state <= in? 4'b0100 : 4'b0010; // B
            4'b0010: state <= in? 4'b0001 : 4'b1000; // C
            4'b0001: state <= in? 4'b0100 : 4'b0010; // D
            default: state <= 4'b1000; // Default to A
        endcase
    end
end

// Determine the output directly from the state using assign
assign out = state[0] ? 0 : (state[1] ? 0 : (state[2] ? 0 : 1));

endmodule