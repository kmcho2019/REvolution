`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state, next_state;

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        out <= 0;
    end else begin
        case (state)
            2'b00: begin // A
                state <= in ? 2'b01 : 2'b00;
                out <= 0;
            end
            2'b01: begin // B
                state <= in ? 2'b01 : 2'b10;
                out <= 0;
            end
            2'b10: begin // C
                state <= in ? 2'b11 : 2'b00;
                out <= 0;
            end
            2'b11: begin // D
                state <= in ? 2'b01 : 2'b10;
                out <= 1;
            end
        endcase
    end
end

endmodule