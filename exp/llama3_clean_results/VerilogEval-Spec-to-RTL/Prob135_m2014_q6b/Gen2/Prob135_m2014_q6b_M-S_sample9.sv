module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    // next-state logic for y[1]
    // We can use a case statement to handle each state separately
    // and determine the next state based on the input w
    always @(*) begin
        case (y)
            3'b000: Y1 = 0; // State A: y[1] is 0
            3'b001: Y1 = 1; // State B: y[1] is 1
            3'b010: Y1 = 1; // State C: y[1] is 1
            3'b011: Y1 = ~w ? 1 : 0; // State D: y[1] is 1 if w is 0, 0 if w is 1
            3'b100: Y1 = 1; // State E: y[1] is 1
            3'b101: Y1 = 1; // State F: y[1] is 1
            default: Y1 = 0;
        endcase
    end
endmodule