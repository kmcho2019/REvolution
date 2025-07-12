module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs as {a,b,c,d,e} with inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to calculate output bit index based on (i,j)
    // Mapping: out[24 - (5*i + j)] corresponds to comparison inputs[i], inputs[j]
    function automatic int out_idx(input int i, input int j);
        begin
            out_idx = 24 - (5*i + j);
        end
    endfunction

    genvar i, j;
    generate
        // Only compute upper triangle and diagonal (i <= j)
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = i; j < 5; j = j + 1) begin : gen_j_upper
                localparam int idx = out_idx(i, j);
                assign out[idx] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

    // Assign lower triangle bits (i > j) by reusing the symmetric upper triangle bits
    assign out[out_idx(1,0)] = out[out_idx(0,1)];
    assign out[out_idx(2,0)] = out[out_idx(0,2)];
    assign out[out_idx(2,1)] = out[out_idx(1,2)];
    assign out[out_idx(3,0)] = out[out_idx(0,3)];
    assign out[out_idx(3,1)] = out[out_idx(1,3)];
    assign out[out_idx(3,2)] = out[out_idx(2,3)];
    assign out[out_idx(4,0)] = out[out_idx(0,4)];
    assign out[out_idx(4,1)] = out[out_idx(1,4)];
    assign out[out_idx(4,2)] = out[out_idx(2,4)];
    assign out[out_idx(4,3)] = out[out_idx(3,4)];

endmodule