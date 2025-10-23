module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs into a vector for easy indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all pairwise equality bits using nested loops
    genvar i, j;
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_row
            for (j = 0; j < 5; j = j + 1) begin : gen_col
                // Calculate the output bit index according to specification:
                // out[24 - (5*i + j)] = (inputs[i] == inputs[j])
                assign temp_out[24 - (5*i + j)] = (inputs[i] == inputs[j]);
            end
        end
    endgenerate

    assign out = temp_out;

endmodule