module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Connection matrix parameters [inputs][outputs]
    // a->w, b->x, b->y, c->z
    parameter [0:2][0:3] CONN_MATRIX = {
        3'b100, // a connections (w)
        3'b011, // b connections (x, y)
        3'b000  // c connections (z)
    };

    // Input and output vectors for cleaner indexing
    wire [2:0] inputs = {a, b, c};
    wire [3:0] outputs;
    assign {w, x, y, z} = outputs;

    genvar i, j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : output_conn
            wire [2:0] conn_sigs;
            for (i = 0; i < 3; i = i + 1) begin : input_conn
                assign conn_sigs[i] = inputs[i] & CONN_MATRIX[i][j];
            end
            assign outputs[j] = |conn_sigs; // OR all potential connections
        end
    endgenerate
endmodule