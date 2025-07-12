module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0][4:0] comparisons;

    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                if (i == 0) begin
                    if (j == 0) assign comparisons[i][j] = (a == a);
                    else if (j == 1) assign comparisons[i][j] = (a == b);
                    else if (j == 2) assign comparisons[i][j] = (a == c);
                    else if (j == 3) assign comparisons[i][j] = (a == d);
                    else assign comparisons[i][j] = (a == e);
                end else if (i == 1) begin
                    if (j == 0) assign comparisons[i][j] = (b == a);
                    else if (j == 1) assign comparisons[i][j] = (b == b);
                    else if (j == 2) assign comparisons[i][j] = (b == c);
                    else if (j == 3) assign comparisons[i][j] = (b == d);
                    else assign comparisons[i][j] = (b == e);
                end else if (i == 2) begin
                    if (j == 0) assign comparisons[i][j] = (c == a);
                    else if (j == 1) assign comparisons[i][j] = (c == b);
                    else if (j == 2) assign comparisons[i][j] = (c == c);
                    else if (j == 3) assign comparisons[i][j] = (c == d);
                    else assign comparisons[i][j] = (c == e);
                end else if (i == 3) begin
                    if (j == 0) assign comparisons[i][j] = (d == a);
                    else if (j == 1) assign comparisons[i][j] = (d == b);
                    else if (j == 2) assign comparisons[i][j] = (d == c);
                    else if (j == 3) assign comparisons[i][j] = (d == d);
                    else assign comparisons[i][j] = (d == e);
                end else begin
                    if (j == 0) assign comparisons[i][j] = (e == a);
                    else if (j == 1) assign comparisons[i][j] = (e == b);
                    else if (j == 2) assign comparisons[i][j] = (e == c);
                    else if (j == 3) assign comparisons[i][j] = (e == d);
                    else assign comparisons[i][j] = (e == e);
                end
            end
        end
    endgenerate

    assign out[24] = comparisons[0][0];
    assign out[23] = comparisons[0][1];
    assign out[22] = comparisons[0][2];
    assign out[21] = comparisons[0][3];
    assign out[20] = comparisons[0][4];
    assign out[19] = comparisons[1][0];
    assign out[18] = comparisons[1][1];
    assign out[17] = comparisons[1][2];
    assign out[16] = comparisons[1][3];
    assign out[15] = comparisons[1][4];
    assign out[14] = comparisons[2][0];
    assign out[13] = comparisons[2][1];
    assign out[12] = comparisons[2][2];
    assign out[11] = comparisons[2][3];
    assign out[10] = comparisons[2][4];
    assign out[9] = comparisons[3][0];
    assign out[8] = comparisons[3][1];
    assign out[7] = comparisons[3][2];
    assign out[6] = comparisons[3][3];
    assign out[5] = comparisons[3][4];
    assign out[4] = comparisons[4][0];
    assign out[3] = comparisons[4][1];
    assign out[2] = comparisons[4][2];
    assign out[1] = comparisons[4][3];
    assign out[0] = comparisons[4][4];

endmodule