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

    reg next_y1;

    always @(y or w) begin
        case ({y, w})
            {STATE_A, 1'b0}: next_y1 = STATE_B[1];
            {STATE_A, 1'b1}: next_y1 = STATE_A[1];
            {STATE_B, 1'b0}: next_y1 = STATE_C[1];
            {STATE_B, 1'b1}: next_y1 = STATE_D[1];
            {STATE_C, 1'b0}: next_y1 = STATE_E[1];
            {STATE_C, 1'b1}: next_y1 = STATE_D[1];
            {STATE_D, 1'b0}: next_y1 = STATE_F[1];
            {STATE_D, 1'b1}: next_y1 = STATE_A[1];
            {STATE_E, 1'b0}: next_y1 = STATE_E[1];
            {STATE_E, 1'b1}: next_y1 = STATE_D[1];
            {STATE_F, 1'b0}: next_y1 = STATE_C[1];
            {STATE_F, 1'b1}: next_y1 = STATE_D[1];
            default: next_y1 = STATE_A[1];
        endcase
    end

    always @(next_y1) begin
        Y1 = next_y1;
    end

endmodule