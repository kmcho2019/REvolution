`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= 1'b1; // A
        z <= 1'b0;
    end else begin
        case (currentState)
            1'b1: begin // A
                currentState <= w? 1'b1 : 1'b10; // A or B
                z <= 1'b0;
            end
            1'b10: begin // B
                currentState <= w? 1'b100 : 1'b1000; // C or D
                z <= 1'b0;
            end
            1'b100: begin // C
                currentState <= w? 1'b1000 : 1'b10000; // D or E
                z <= 1'b0;
            end
            1'b1000: begin // D
                currentState <= w? 1'b1 : 1'b100000; // A or F
                z <= 1'b0;
            end
            1'b10000: begin // E
                currentState <= w? 1'b1000 : 1'b10000; // D or E
                z <= 1'b1;
            end
            1'b100000: begin // F
                currentState <= w? 1'b1000 : 1'b100; // D or C
                z <= 1'b1;
            end
            default: begin
                currentState <= 1'b1; // default to A
                z <= 1'b0;
            end
        endcase
    end
end

endmodule