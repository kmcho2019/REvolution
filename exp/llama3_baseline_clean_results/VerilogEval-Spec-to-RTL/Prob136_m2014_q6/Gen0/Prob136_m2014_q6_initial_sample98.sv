module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] currentState; // 3 bits to represent 6 states
reg [2:0] nextState;

always @(*) begin
    case(currentState)
        3'b000: // State A
            if(w)
                nextState = 3'b000; // A
            else
                nextState = 3'b001; // B
        3'b001: // State B
            if(w)
                nextState = 3'b011; // D
            else
                nextState = 3'b010; // C
        3'b010: // State C
            if(w)
                nextState = 3'b011; // D
            else
                nextState = 3'b100; // E
        3'b011: // State D
            if(w)
                nextState = 3'b000; // A
            else
                nextState = 3'b101; // F
        3'b100: // State E
            if(w)
                nextState = 3'b011; // D
            else
                nextState = 3'b100; // E
        3'b101: // State F
            if(w)
                nextState = 3'b011; // D
            else
                nextState = 3'b010; // C
        default:
            nextState = 3'b000; // A
    endcase
end

always @(posedge clk) begin
    if(reset)
        currentState <= 3'b000; // Reset to state A
    else
        currentState <= nextState;
end

always @(*) begin
    case(currentState)
        3'b000: z = 0; // State A
        3'b001: z = 0; // State B
        3'b010: z = 0; // State C
        3'b011: z = 0; // State D
        3'b100: z = 1; // State E
        3'b101: z = 1; // State F
        default: z = 0; // Default output
    endcase
end

endmodule