`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// One-hot encoding for states
reg [5:0] currentState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b1; // Reset to state A
    end else begin
        case (1'b1)
            currentState[0]: currentState <= w ? 6'b1 : 6'b10; // A
            currentState[1]: currentState <= w ? 6'b1000 : 6'b100; // B
            currentState[2]: currentState <= w ? 6'b1000 : 6'b10000; // C
            currentState[3]: currentState <= w ? 6'b1 : 6'b100000; // D
            currentState[4]: currentState <= w ? 6'b1000 : 6'b100000; // E
            currentState[5]: currentState <= w ? 6'b100 : 6'b100000; // F
            default: currentState <= 6'b1;
        endcase
    end
end

// Output z logic
assign z = currentState[4] || currentState[5]; // z = 1 if in state E or F

endmodule