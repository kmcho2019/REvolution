`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [5:0] currentState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b000001;
    end else begin
        case (1'b1)
            currentState[0]: currentState <= w ? 6'b000001 : 6'b000010;
            currentState[1]: currentState <= w ? 6'b000100 : 6'b001000;
            currentState[2]: currentState <= w ? 6'b000100 : 6'b010000;
            currentState[3]: currentState <= w ? 6'b000001 : 6'b100000;
            currentState[4]: currentState <= w ? 6'b000100 : 6'b010000;
            currentState[5]: currentState <= w ? 6'b000100 : 6'b001000;
        endcase
    end
end

// Output z logic
assign z = currentState[4] | currentState[5];

endmodule