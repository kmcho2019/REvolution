module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    reg [2:0] next_state;

    always @(y or w)
    begin
        case (y)
            STATE_A: next_state = ~w ? STATE_B : STATE_A;
            STATE_B: next_state = ~w ? STATE_C : STATE_D;
            STATE_C: next_state = ~w ? STATE_E : STATE_D;
            STATE_D: next_state = ~w ? STATE_F : STATE_A;
            STATE_E: next_state = ~w ? STATE_E : STATE_D;
            STATE_F: next_state = ~w ? STATE_C : STATE_D;
            default: next_state = STATE_A;
        endcase
    end

    assign Y1 = next_state[1];

endmodule