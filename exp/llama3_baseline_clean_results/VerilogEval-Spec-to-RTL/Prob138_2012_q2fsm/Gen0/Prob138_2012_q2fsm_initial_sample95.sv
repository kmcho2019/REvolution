module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;

// Combinational logic to determine next state
always @(*) begin
    case (currentState)
        3'b000: // A
            if (w == 1'b1)
                nextState = 3'b001; // B
            else
                nextState = 3'b000; // A
        3'b001: // B
            if (w == 1'b1)
                nextState = 3'b010; // C
            else
                nextState = 3'b011; // D
        3'b010: // C
            if (w == 1'b1)
                nextState = 3'b100; // E
            else
                nextState = 3'b011; // D
        3'b011: // D
            if (w == 1'b1)
                nextState = 3'b101; // F
            else
                nextState = 3'b000; // A
        3'b100: // E
            if (w == 1'b1)
                nextState = 3'b100; // E
            else
                nextState = 3'b011; // D
        3'b101: // F
            if (w == 1'b1)
                nextState = 3'b010; // C
            else
                nextState = 3'b011; // D
        default:
            nextState = 3'b000; // A
    endcase
end

// Sequential logic to update current state
always @(posedge clk) begin
    if (reset == 1'b1)
        currentState <= 3'b000; // A
    else
        currentState <= nextState;
end

// Continuous assignment for output z
assign z = (currentState == 3'b100) || (currentState == 3'b101);

endmodule