`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states as a binary counter
reg [1:0] state;

// Initialize the state to A (00)
initial state = 2'b00;

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        out <= 0;
    end else begin
        case (state)
            2'b00: begin // A
                if (in) state <= 2'b01; // Transition to B
                out <= 0;
            end
            2'b01: begin // B
                if (!in) state <= 2'b10; // Transition to C
                out <= 0;
            end
            2'b10: begin // C
                if (in) state <= 2'b11; // Transition to D
                else state <= 2'b00; // Transition to A
                out <= 0;
            end
            2'b11: begin // D
                if (in) state <= 2'b01; // Transition to B
                else state <= 2'b10; // Transition to C
                out <= 1;
            end
        endcase
    end
end

endmodule