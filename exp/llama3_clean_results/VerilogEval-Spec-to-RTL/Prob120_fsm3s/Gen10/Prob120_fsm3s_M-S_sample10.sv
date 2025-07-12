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
        state <= 2'b00;
        out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                state <= in? 2'b01 : 2'b00;
                out <= 1'b0;
            end
            2'b01: begin
                state <= in? 2'b01 : 2'b10;
                out <= 1'b0;
            end
            2'b10: begin
                state <= in? 2'b11 : 2'b00;
                out <= 1'b0;
            end
            2'b11: begin
                state <= in? 2'b01 : 2'b10;
                out <= 1'b1;
            end
        endcase
    end
end

endmodule