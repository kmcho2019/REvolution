module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    reg [2:0] nextState;

    always @(y, w) begin
        case (y)
            3'b000: nextState = (w == 1'b0)? 3'b001 : 3'b000; // State A transitions
            3'b001: nextState = (w == 1'b0)? 3'b010 : 3'b011; // State B transitions
            3'b010: nextState = (w == 1'b0)? 3'b100 : 3'b011; // State C transitions
            3'b011: nextState = (w == 1'b0)? 3'b101 : 3'b000; // State D transitions
            3'b100: nextState = (w == 1'b0)? 3'b100 : 3'b011; // State E transitions
            3'b101: nextState = (w == 1'b0)? 3'b010 : 3'b011; // State F transitions
            default: nextState = 3'b000;
        endcase
        Y1 = nextState[1];
    end

endmodule