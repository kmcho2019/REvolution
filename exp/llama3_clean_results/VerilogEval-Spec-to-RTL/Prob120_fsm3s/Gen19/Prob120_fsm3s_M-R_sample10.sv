`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state;

initial state = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (in) begin
                    state <= 2'b01; // Next state B
                end else begin
                    state <= 2'b00; // Next state A
                end
                out <= 0;
            end
            2'b01: begin // State B
                if (in) begin
                    state <= 2'b01; // Next state B
                end else begin
                    state <= 2'b10; // Next state C
                end
                out <= 0;
            end
            2'b10: begin // State C
                if (in) begin
                    state <= 2'b11; // Next state D
                end else begin
                    state <= 2'b00; // Next state A
                end
                out <= 0;
            end
            2'b11: begin // State D
                if (in) begin
                    state <= 2'b01; // Next state B
                end else begin
                    state <= 2'b10; // Next state C
                end
                out <= 1;
            end
            default: begin
                state <= 2'b00; // Default next state A
                out <= 0;
            end
        endcase
    end
end

endmodule