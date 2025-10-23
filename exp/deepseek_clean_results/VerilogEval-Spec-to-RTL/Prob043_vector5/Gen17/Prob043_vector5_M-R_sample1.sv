module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    localparam NUM_INPUTS = 5;
    localparam TOTAL_COMPARISONS = NUM_INPUTS * NUM_INPUTS;
    
    wire [NUM_INPUTS-1:0] inputs = {e, d, c, b, a};
    genvar i, j;
    
    generate
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin : row_gen
            for (j = 0; j < NUM_INPUTS; j = j + 1) begin : col_gen
                assign out[(NUM_INPUTS-1-i)*NUM_INPUTS + (NUM_INPUTS-1-j)] = 
                       ~inputs[i] ^ inputs[j];
            end
        end
    endgenerate

endmodule