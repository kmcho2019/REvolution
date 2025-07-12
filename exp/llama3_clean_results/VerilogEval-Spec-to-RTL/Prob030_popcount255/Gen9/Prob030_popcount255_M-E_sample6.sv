module TopModule(
    input [254:0] in,
    output [7:0] out
);

parameter STAGES = 8;
parameter GROUP_SIZE = 32;

wire [STAGES-1:0][GROUP_SIZE-1:0] counts;

// Divide the input vector into groups of bits and count the number of '1's within each group
genvar i;
generate
    for (i = 0; i < STAGES; i++) begin
        BitCounter bit_counter(in[(i*GROUP_SIZE)+:GROUP_SIZE], counts[i]);
    end
endgenerate

// Combine the counts using a compressor tree
wire [STAGES-1:0][3:0] compressed_counts;
assign compressed_counts[0] = counts[0];
genvar j;
generate
    for (j = 1; j < STAGES; j++) begin
        Compressor compressor(counts[j], compressed_counts[j-1], compressed_counts[j]);
    end
endgenerate

// Final adder stage
assign out = compressed_counts[STAGES-1];

endmodule

module BitCounter(
    input [31:0] in,
    output [4:0] out
);

assign out = {1'b0, in[31:28]} + {1'b0, in[27:24]} + {1'b0, in[23:20]} + {1'b0, in[19:16]} +
             {1'b0, in[15:12]} + {1'b0, in[11:8]} + {1'b0, in[7:4]} + {1'b0, in[3:0]};

endmodule

module Compressor(
    input [4:0] a,
    input [4:0] b,
    output [4:0] out
);

assign out = a + b;

endmodule