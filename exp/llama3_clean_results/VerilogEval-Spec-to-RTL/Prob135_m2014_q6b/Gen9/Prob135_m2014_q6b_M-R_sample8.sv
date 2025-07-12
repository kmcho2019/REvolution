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
            STATE_A:
                if (~w) next_state = STATE_B;
                else next_state = STATE_A;
            STATE_B:
                if (~w) next_state = STATE_C;
                else next_state = STATE_D;
            STATE_C:
                if (~w) next_state = STATE_E;
                else next_state = STATE_D;
            STATE_D:
                if (~w) next_state = STATE_F;
                else next_state = STATE_A;
            STATE_E:
                if (~w) next_state = STATE_E;
                else next_state = STATE_D;
            STATE_F:
                if (~w) next_state = STATE_C;
                else next_state = STATE_D;
            default:
                next_state = STATE_A;
        endcase
    end

    assign Y1 = next_state[1];

endmodule