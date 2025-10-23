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
        currentState <= 1; // Initialize to state A
    end else begin
        case (1'b1)
            currentState[0]: currentState <= w ? 1 : 6'b000001; // A
            currentState[1]: currentState <= w ? 6'b000010 : 6'b000100; // B
            currentState[2]: currentState <= w ? 6'b001000 : 6'b010000; // C
            currentState[3]: currentState <= w ? 6'b000001 : 6'b100000; // D
            currentState[4]: currentState <= w ? 6'b000100 : 6'b010000; // E
            currentState[5]: currentState <= w ? 6'b010000 : 6'b000100; // F
            default: currentState <= 1;
        endcase
    end
end

// Output z logic
assign z = currentState[4] | currentState[5]; // Simplified output z logic

endmodule