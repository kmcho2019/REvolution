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

    always @(y or w)
    begin
        case (y)
            STATE_A:
                Y1 = (~w) ? STATE_B[1] : STATE_A[1];
            STATE_B:
                Y1 = (~w) ? STATE_C[1] : STATE_D[1];
            STATE_C:
                Y1 = (~w) ? STATE_E[1] : STATE_D[1];
            STATE_D:
                Y1 = (~w) ? STATE_F[1] : STATE_A[1];
            STATE_E:
                Y1 = (~w) ? STATE_E[1] : STATE_D[1];
            STATE_F:
                Y1 = (~w) ? STATE_C[1] : STATE_D[1];
            default:
                Y1 = STATE_A[1];
        endcase
    end

endmodule