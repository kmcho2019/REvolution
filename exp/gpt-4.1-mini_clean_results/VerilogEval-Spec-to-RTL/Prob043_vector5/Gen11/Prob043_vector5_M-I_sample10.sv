module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};
    genvar i, j;
    // Temporary wire array to hold comparison bits
    wire [4:0][4:0] comp;

    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign comp[i][j] = in_vec[i] ^~ in_vec[j];
            end
        end
    endgenerate

    // Map comp[i][j] to out bit indices as per given ordering:
    // out[24] = comp[4][4] (a vs a)
    // out[23] = comp[4][3] (a vs b)
    // ...
    // out[0]  = comp[0][0] (e vs e)
    integer idx;
    always @* begin
        for (idx = 0; idx < 25; idx = idx +1) begin
            // Calculate i and j from idx for out indexing:
            // out[24 - (5*i + j)] = comp[4 - i][4 - j]
            // To preserve ordering:
            // Indexing scheme: i = idx / 5, j = idx % 5
            // out[24 - idx] = comp[4 - i][4 - j]
        end
    end

    // Because generate and always block cannot assign to same net,
    // we must assign out bits individually.
    assign out[24] = comp[4][4]; // a vs a
    assign out[23] = comp[4][3]; // a vs b
    assign out[22] = comp[4][2]; // a vs c
    assign out[21] = comp[4][1]; // a vs d
    assign out[20] = comp[4][0]; // a vs e

    assign out[19] = comp[3][4]; // b vs a
    assign out[18] = comp[3][3]; // b vs b
    assign out[17] = comp[3][2]; // b vs c
    assign out[16] = comp[3][1]; // b vs d
    assign out[15] = comp[3][0]; // b vs e

    assign out[14] = comp[2][4]; // c vs a
    assign out[13] = comp[2][3]; // c vs b
    assign out[12] = comp[2][2]; // c vs c
    assign out[11] = comp[2][1]; // c vs d
    assign out[10] = comp[2][0]; // c vs e

    assign out[9]  = comp[1][4]; // d vs a
    assign out[8]  = comp[1][3]; // d vs b
    assign out[7]  = comp[1][2]; // d vs c
    assign out[6]  = comp[1][1]; // d vs d
    assign out[5]  = comp[1][0]; // d vs e

    assign out[4]  = comp[0][4]; // e vs a
    assign out[3]  = comp[0][3]; // e vs b
    assign out[2]  = comp[0][2]; // e vs c
    assign out[1]  = comp[0][1]; // e vs d
    assign out[0]  = comp[0][0]; // e vs e

endmodule