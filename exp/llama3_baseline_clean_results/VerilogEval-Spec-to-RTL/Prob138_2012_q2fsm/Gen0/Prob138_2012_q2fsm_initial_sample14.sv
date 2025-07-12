module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state;
reg [2:0] nextState;

// State table
always @(*)
begin
    case (state)
        3'b000: // A
            if (w) nextState = 3'b001; // B
            else nextState = 3'b000; // A
        3'b001: // B
            if (w) nextState = 3'b010; // C
            else nextState = 3'b011; // D
        3'b010: // C
            if (w) nextState = 3'b100; // E
            else nextState = 3'b011; // D
        3'b011: // D
            if (w) nextState = 3'b101; // F
            else nextState = 3'b000; // A
        3'b100: // E
            if (w) nextState = 3'b100; // E
            else nextState = 3'b011; // D
        3'b101: // F
            if (w) nextState = 3'b010; // C
            else nextState = 3'b011; // D
        default: nextState = 3'b000; // A
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (reset) state <= 3'b000; // A
    else state <= nextState;
end

// FSM output
assign z = (state == 3'b100 || state == 3'b101); // z is 1 when in state E or F

endmodule