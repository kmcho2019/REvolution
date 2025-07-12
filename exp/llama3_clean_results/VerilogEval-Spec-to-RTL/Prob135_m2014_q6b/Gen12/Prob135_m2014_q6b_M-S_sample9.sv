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

    reg Y1_next;

    always @(y or w)
    begin
        case (y)
            STATE_A:
                Y1_next = 0;
            STATE_B:
                Y1_next = w? 0 : 1;
            STATE_C:
                Y1_next = w? 0 : 1;
            STATE_D:
                Y1_next = w? 0 : 1;
            STATE_E:
                Y1_next = w? 0 : 1;
            STATE_F:
                Y1_next = w? 0 : 1;
            default:
                Y1_next = 0;
        endcase
    end

    assign Y1 = Y1_next;

endmodule