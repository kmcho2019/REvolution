module TopModule(
    input  [2:0] y,  // current state
    input  w,     // input
    output Y1     // output y[1]
);

// Next-state logic for y[1]
always @(y or w)
begin
    case (y)
        3'b000: Y1 = ~w;  // State A
        3'b001: Y1 = ~w;  // State B
        3'b010: Y1 = ~w;  // State C
        3'b011: Y1 = ~w;  // State D
        3'b100: Y1 =  w;  // State E
        3'b101: Y1 =  w;  // State F
        default: Y1 = 1'b0;
    endcase
end

endmodule