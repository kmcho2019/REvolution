module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// First level: count '1's in each group of 8 bits
wire [31:0] counts; // Each bit represents the count for each byte
genvar i;
generate
    for (i = 0; i < 32; i++) begin
        byte_counter byte_counter_i (
            .in(in[(i*8)+7:(i*8)]),
            .out(counts[i])
        );
    end
endgenerate

// Second level: sum up counts from first level using a tree-like adder structure
wire [15:0] sums;
genvar j;
generate
    for (j = 0; j < 16; j++) begin
        adder_2bit adder_2bit_j (
            .a(counts[j*2]),
            .b(counts[j*2+1]),
            .sum(sums[j])
        );
    end
endgenerate

// Third level: continue summing up until we have a single count
wire [7:0] sum_sums;
genvar k;
generate
    for (k = 0; k < 8; k++) begin
        adder_2bit adder_2bit_k (
            .a(sums[k*2]),
            .b(sums[k*2+1]),
            .sum(sum_sums[k])
        );
    end
endgenerate

// Fourth level: final sum to get the population count
assign out = sum_sums[0] + sum_sums[1] + sum_sums[2] + sum_sums[3] + sum_sums[4] + sum_sums[5] + sum_sums[6] + sum_sums[7];

// Helper modules for counting '1's in a byte and adding two bits
module byte_counter(
    input [7:0] in,
    output [7:0] out
);
    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
endmodule

module adder_2bit(
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum
);
    assign sum = a + b;
endmodule

endmodule