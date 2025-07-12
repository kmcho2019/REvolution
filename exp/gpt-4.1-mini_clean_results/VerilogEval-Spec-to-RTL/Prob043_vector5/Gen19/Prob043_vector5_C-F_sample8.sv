module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs into vector [0]=a, [1]=b, [2]=c, [3]=d, [4]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare 2D wire array to store upper triangle (i <= j) XNOR results
    wire cmp[0:4][0:4];

    genvar i, j;
    generate
        // Compute upper triangle and diagonal (i <= j)
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = i; j < 5; j = j + 1) begin : gen_j
                assign cmp[i][j] = inputs[i] ~^ inputs[j];
            end
        end

        // Assign lower triangle (i > j) by mirroring upper triangle (j,i)
        for (i = 0; i < 5; i = i + 1) begin : gen_i_lower
            for (j = 0; j < i; j = j + 1) begin : gen_j_lower
                assign cmp[i][j] = cmp[j][i];
            end
        end

        // Assign output bits: out[24 - (5*i + j)] = cmp[i][j]
        for (i = 0; i < 5; i = i + 1) begin : gen_out_i
            for (j = 0; j < 5; j = j + 1) begin : gen_out_j
                localparam int idx = 5*i + j;
                assign out[24 - idx] = cmp[i][j];
            end
        end
    endgenerate

endmodule