`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using a two-bit counter
reg [1:0] state;
reg [1:0] next_state;

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        out <= 0;
    end else begin
        case(state)
            2'b00: begin
                if (in) next_state <= 2'b01;
                else next_state <= 2'b00;
                out <= 0;
            end
            2'b01: begin
                if (in) next_state <= 2'b01;
                else next_state <= 2'b10;
                out <= 0;
            end
            2'b10: begin
                if (in) next_state <= 2'b11;
                else next_state <= 2'b00;
                out <= 0;
            end
            2'b11: begin
                if (in) next_state <= 2'b01;
                else next_state <= 2'b10;
                out <= 1;
            end
        endcase
        state <= next_state;
    end
end

endmodule