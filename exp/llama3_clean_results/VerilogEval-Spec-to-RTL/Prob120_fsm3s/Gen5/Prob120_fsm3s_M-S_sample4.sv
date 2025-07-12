`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state = 2'b00; // Initialize state to A (00)

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case (state)
            2'b00: state <= in? 2'b01 : 2'b00; // A
            2'b01: state <= in? 2'b01 : 2'b10; // B
            2'b10: state <= in? 2'b11 : 2'b00; // C
            2'b11: state <= in? 2'b01 : 2'b10; // D
        endcase
    end
    out <= (state == 2'b11); // Output is 1 only when in state D
end

endmodule