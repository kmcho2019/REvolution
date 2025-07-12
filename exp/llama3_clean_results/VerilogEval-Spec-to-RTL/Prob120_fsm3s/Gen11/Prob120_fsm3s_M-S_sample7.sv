`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state;

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case (state)
            2'b00: if (!in) state <= 2'b00; else state <= 2'b01; // A
            2'b01: if (!in) state <= 2'b10; else state <= 2'b01; // B
            2'b10: if (!in) state <= 2'b00; else state <= 2'b11; // C
            2'b11: if (!in) state <= 2'b10; else state <= 2'b01; // D
            default: state <= 2'b00; // Default to A
        endcase
    end
    // Determine the output based on the current state
    case (state)
        2'b00, 2'b01, 2'b10: out <= 0; // A, B, C
        2'b11: out <= 1; // D
    endcase
end

endmodule