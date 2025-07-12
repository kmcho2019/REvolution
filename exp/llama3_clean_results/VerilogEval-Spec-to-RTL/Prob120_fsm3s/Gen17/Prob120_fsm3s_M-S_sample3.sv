`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case (state)
            2'b00: state <= in ? 2'b01 : 2'b00; // State A transitions
            2'b01: state <= in ? 2'b01 : 2'b10; // State B transitions
            2'b10: state <= in ? 2'b11 : 2'b00; // State C transitions
            2'b11: state <= in ? 2'b01 : 2'b10; // State D transitions
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // Outputs for states A, B, C
        2'b11: out = 1'b1; // Output for state D
    endcase
end

endmodule