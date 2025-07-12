`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using a two-bit counter
reg [1:0] state;

// Initialize the state to A (00)
initial state = 2'b00;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        out <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (!in) begin
                    state <= 2'b00;
                end else begin
                    state <= 2'b01;
                end
                out <= 0;
            end
            2'b01: begin // State B
                if (!in) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
                out <= 0;
            end
            2'b10: begin // State C
                if (!in) begin
                    state <= 2'b00;
                end else begin
                    state <= 2'b11;
                end
                out <= 0;
            end
            2'b11: begin // State D
                if (!in) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
                out <= 1;
            end
        endcase
    end
end

endmodule