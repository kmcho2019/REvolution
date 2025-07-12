`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 0;
    end else begin
        case (currentState)
            3'b000: currentState <= w ? 3'b000 : 3'b001;
            3'b001: currentState <= w ? 3'b011 : 3'b010;
            3'b010: currentState <= w ? 3'b011 : 3'b100;
            3'b011: currentState <= w ? 3'b000 : 3'b101;
            3'b100: currentState <= w ? 3'b011 : 3'b100;
            3'b101: currentState <= w ? 3'b011 : 3'b010;
            default: currentState <= 0;
        endcase
    end
end

// Output z logic
always @(posedge clk) begin
    case (currentState)
        3'b100, 3'b101: z <= 1;
        default: z <= 0;
    endcase
end

endmodule