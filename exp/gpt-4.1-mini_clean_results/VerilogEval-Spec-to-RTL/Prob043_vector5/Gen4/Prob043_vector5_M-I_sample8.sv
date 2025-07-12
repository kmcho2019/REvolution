module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Map inputs to array for indexing
    wire inputs[4:0];
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    // Function to compute output bit index from (i,j)
    function automatic int out_idx(input int i, input int j);
        begin
            // index from 24 down to 0 in row-major order
            out_idx = 24 - (5*i + j);
        end
    endfunction

    genvar i, j;
    generate
        // Loop over all pairs
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                if (i <= j) begin
                    // Upper triangular including diagonal: compute equality
                    assign out[out_idx(i,j)] = ~(inputs[i] ^ inputs[j]);
                end else begin
                    // Lower triangular: reuse the symmetrical upper triangular output
                    assign out[out_idx(i,j)] = out[out_idx(j,i)];
                end
            end
        end
    endgenerate
endmodule