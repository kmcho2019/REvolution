module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Function to count the number of '1's in an 8-bit vector
function [7:0] count_ones;
    input [7:0] in;
    begin
        count_ones = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                     {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};
    end
endfunction

// Count the number of '1's in each 8-bit chunk
wire [7:0] chunk_count [31:0];
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : chunk_count_gen
        if (i < 31) begin
            assign chunk_count[i] = count_ones(in[(i*8) +: 8]);
        end else begin
            assign chunk_count[i] = count_ones({1'b0, in[(i*8) +: 7]});
        end
    end
endgenerate

// Tree-like structure to sum up the counts from each chunk
wire [7:0] level1_count [15:0];
wire [7:0] level2_count [7:0];
wire [7:0] level3_count [3:0];
wire [7:0] level4_count [1:0];
wire [7:0] level5_count;

genvar j;
generate
    for (j = 0; j < 16; j = j + 1) begin : level1_count_gen
        assign level1_count[j] = chunk_count[2*j] + chunk_count[2*j+1];
    end
endgenerate

genvar k;
generate
    for (k = 0; k < 8; k = k + 1) begin : level2_count_gen
        assign level2_count[k] = level1_count[2*k] + level1_count[2*k+1];
    end
endgenerate

genvar l;
generate
    for (l = 0; l < 4; l = l + 1) begin : level3_count_gen
        assign level3_count[l] = level2_count[2*l] + level2_count[2*l+1];
    end
endgenerate

genvar m;
generate
    for (m = 0; m < 2; m = m + 1) begin : level4_count_gen
        assign level4_count[m] = level3_count[2*m] + level3_count[2*m+1];
    end
endgenerate

assign level5_count = level4_count[0] + level4_count[1];

assign out = level5_count;

endmodule