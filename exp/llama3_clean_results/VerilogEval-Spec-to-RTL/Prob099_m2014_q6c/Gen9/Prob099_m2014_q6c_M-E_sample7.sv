module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

reg [5:0] currentState;

always @(*) begin
    case (1'b1)
        y[0]: // State A
            if (~w) currentState = 6'b000010; // Next state B
            else currentState = 6'b000001; // Stay in state A
        y[1]: // State B
            if (~w) currentState = 6'b000100; // Next state C
            else currentState = 6'b001000; // Next state D
        y[2]: // State C
            if (~w) currentState = 6'b100000; // Next state E
            else currentState = 6'b001000; // Next state D
        y[3]: // State D
            if (~w) currentState = 6'b010000; // Next state F
            else currentState = 6'b000001; // Next state A
        y[4]: // State E
            if (w) currentState = 6'b001000; // Next state D
            else currentState = 6'b100000; // Stay in state E
        y[5]: // State F
            if (w) currentState = 6'b001000; // Next state D
            else currentState = 6'b000100; // Next state C
        default: currentState = 6'b000001; // Reset to state A
    endcase
end

assign Y1 = currentState[0]; // State A
assign Y3 = currentState[2]; // State C

endmodule