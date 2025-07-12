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

    reg next_Y1;

    always @(y or w)
    begin
        case (y)
            STATE_A:
                if (~w) next_Y1 = 1'b0;
                else next_Y1 = 1'b0;
            STATE_B:
                if (~w) next_Y1 = 1'b1;
                else next_Y1 = 1'b0;
            STATE_C:
                if (~w) next_Y1 = 1'b0;
                else next_Y1 = 1'b0;
            STATE_D:
                if (~w) next_Y1 = 1'b1;
                else next_Y1 = 1'b0;
            STATE_E:
                if (~w) next_Y1 = 1'b0;
                else next_Y1 = 1'b0;
            STATE_F:
                if (~w) next_Y1 = 1'b0;
                else next_Y1 = 1'b0;
            default:
                next_Y1 = 1'b0;
        endcase
    end

    assign Y1 = next_Y1;

endmodule