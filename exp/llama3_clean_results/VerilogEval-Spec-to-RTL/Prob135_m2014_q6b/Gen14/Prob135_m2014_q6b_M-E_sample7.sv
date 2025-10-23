module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam LUT_A [1:0] = '{1'b0, 1'b0}; // For state A, next_state_y1 is 0 for w=0, 0 for w=1
    localparam LUT_B [1:0] = '{1'b0, 1'b1}; // For state B, next_state_y1 is 0 for w=0, 1 for w=1
    localparam LUT_C [1:0] = '{1'b0, 1'b1}; // For state C, next_state_y1 is 0 for w=0, 1 for w=1
    localparam LUT_D [1:0] = '{1'b1, 1'b0}; // For state D, next_state_y1 is 1 for w=0, 0 for w=1
    localparam LUT_E [1:0] = '{1'b1, 1'b1}; // For state E, next_state_y1 is 1 for w=0, 1 for w=1
    localparam LUT_F [1:0] = '{1'b0, 1'b1}; // For state F, next_state_y1 is 0 for w=0, 1 for w=1

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
                next_state[1] = LUT_A[~w];
            STATE_B:
                next_state[1] = LUT_B[~w];
            STATE_C:
                next_state[1] = LUT_C[~w];
            STATE_D:
                next_state[1] = LUT_D[~w];
            STATE_E:
                next_state[1] = LUT_E[~w];
            STATE_F:
                next_state[1] = LUT_F[~w];
            default:
                next_state[1] = 1'b0;
        endcase
    end

    assign Y1 = next_state[1];

endmodule