`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [5:0] currentState; // One-hot encoding

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b000001; // Reset to state A
    end else begin
        case (1'b1)
            currentState[0]: currentState <= w? 6'b000001 : 6'b000010; // State A
            currentState[1]: currentState <= w? 6'b000100 : 6'b001000; // State B
            currentState[2]: currentState <= w? 6'b000100 : 6'b010000; // State C
            currentState[3]: currentState <= w? 6'b000001 : 6'b100000; // State D
            currentState[4]: currentState <= w? 6'b010000 : 6'b000100; // State E
            currentState[5]: currentState <= w? 6'b000010 : 6'b000100; // State F
            default: currentState <= 6'b000001;
        endcase
    end
end

// Output z logic
assign z = currentState[4] | currentState[5]; // Output z is 1 when in state E or F

endmodule