module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    reg [2:0] nextState;

    always @(y or w) begin
        case (y)
            STATE_A: nextState = (w == 1'b0)? STATE_B : STATE_A; // State A transitions
            STATE_B: nextState = (w == 1'b0)? STATE_C : STATE_D; // State B transitions
            STATE_C: nextState = (w == 1'b0)? STATE_E : STATE_D; // State C transitions
            STATE_D: nextState = (w == 1'b0)? STATE_F : STATE_A; // State D transitions
            STATE_E: nextState = (w == 1'b0)? STATE_E : STATE_D; // State E transitions
            STATE_F: nextState = (w == 1'b0)? STATE_C : STATE_D; // State F transitions
            default: nextState = STATE_A;
        endcase
        Y1 = nextState[1];
    end

endmodule