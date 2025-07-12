module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    localparam N = 5;
    wire [N-1:0] inputs = {e, d, c, b, a};
    genvar i, j;

    generate
        for (i = 0; i < N; i = i + 1) begin : row
            for (j = 0; j < N; j = j + 1) begin : col
                assign out[(N-1-i)*N + (N-1-j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule