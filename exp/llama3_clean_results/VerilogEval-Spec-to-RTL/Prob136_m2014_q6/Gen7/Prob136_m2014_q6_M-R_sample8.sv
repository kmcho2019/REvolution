`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as one-hot encoded
reg [5:0] currentState;
wire [5:0] nextState;

// Output z logic
assign z = currentState[4] | currentState[5];

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 6'b000001;  // Initialize to state A (0)
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
assign nextState = (
    (currentState[0] & ~w)? 6'b000010 :  // A -> B
    (currentState[0] & w) ? 6'b000001 :  // A -> A
    (currentState[1] & ~w)? 6'b000100 :  // B -> C
    (currentState[1] & w) ? 6'b001000 :  // B -> D
    (currentState[2] & ~w)? 6'b010000 :  // C -> E
    (currentState[2] & w) ? 6'b001000 :  // C -> D
    (currentState[3] & ~w)? 6'b100000 :  // D -> F
    (currentState[3] & w) ? 6'b000001 :  // D -> A
    (currentState[4] & ~w)? 6'b010000 :  // E -> E
    (currentState[4] & w) ? 6'b001000 :  // E -> D
    (currentState[5] & ~w)? 6'b000100 :  // F -> C
    (currentState[5] & w) ? 6'b001000 :  // F -> D
    6'b000001               // Default to state A
);

endmodule