module TopModule(
    input clk,
    input reset,
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Define the current state and next state
reg [5:0] currentState, nextState;

// Combinational logic for next state
always @(*)
begin
    // Default next state is the current state
    nextState = currentState;
    
    // State transitions
    case (currentState)
        6'b000001: // State A
            if (~w) nextState = 6'b000010; // A -> B
            else nextState = 6'b000001; // A -> A
        6'b000010: // State B
            if (~w) nextState = 6'b000100; // B -> C
            else nextState = 6'b001000; // B -> D
        6'b000100: // State C
            if (~w) nextState = 6'b010000; // C -> E
            else nextState = 6'b001000; // C -> D
        6'b001000: // State D
            if (~w) nextState = 6'b100000; // D -> F
            else nextState = 6'b000001; // D -> A
        6'b010000: // State E
            if (w) nextState = 6'b001000; // E -> D
            else nextState = 6'b010000; // E -> E
        6'b100000: // State F
            if (w) nextState = 6'b001000; // F -> D
            else nextState = 6'b000100; // F -> C
        default: nextState = 6'b000001; // Default to state A
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        currentState <= 6'b000001; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

// Assign outputs
assign Y1 = currentState[1];
assign Y3 = currentState[3];

endmodule