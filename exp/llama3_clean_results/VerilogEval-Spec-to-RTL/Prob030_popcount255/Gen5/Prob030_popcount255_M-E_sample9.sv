module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 32 chunks of 8 bits
wire [7:0] chunk [31:0];

// Generate chunks
genvar i;
generate
    for (i = 0; i < 32; i++) begin
        if (i < 31) begin
            assign chunk[i] = in[(i*8)+:8];
        end else begin
            assign chunk[i] = {1'b0, in[(i*8)+:7]};
        end
    end
endgenerate

// Bit-sliced counter for each chunk
wire [7:0] chunk_count [31:0];

// Population count for each chunk using bit-sliced counter
genvar j;
generate
    for (j = 0; j < 32; j++) begin
        bit_sliced_counter bsc (
            .in(chunk[j]),
            .out(chunk_count[j])
        );
    end
endgenerate

// Hierarchical adder tree to combine outputs from each chunk
wire [7:0] count;

// Level 1: 16 2-to-1 adders
wire [7:0] level1_count [15:0];
genvar k;
generate
    for (k = 0; k < 16; k++) begin
        if (k < 15) begin
            adder_2to1 a2a1 (
                .a(chunk_count[k*2]),
                .b(chunk_count[k*2+1]),
                .out(level1_count[k])
            );
        end else begin
            adder_2to1 a2a1 (
                .a(chunk_count[k*2]),
                .b(8'd0),
                .out(level1_count[k])
            );
        end
    end
endgenerate

// Level 2: 8 2-to-1 adders
wire [7:0] level2_count [7:0];
genvar l;
generate
    for (l = 0; l < 8; l++) begin
        adder_2to1 a2a1 (
            .a(level1_count[l*2]),
            .b(level1_count[l*2+1]),
            .out(level2_count[l])
        );
    end
endgenerate

// Level 3: 4 2-to-1 adders
wire [7:0] level3_count [3:0];
genvar m;
generate
    for (m = 0; m < 4; m++) begin
        adder_2to1 a2a1 (
            .a(level2_count[m*2]),
            .b(level2_count[m*2+1]),
            .out(level3_count[m])
        );
    end
endgenerate

// Level 4: 2 2-to-1 adders
wire [7:0] level4_count [1:0];
genvar n;
generate
    for (n = 0; n < 2; n++) begin
        adder_2to1 a2a1 (
            .a(level3_count[n*2]),
            .b(level3_count[n*2+1]),
            .out(level4_count[n])
        );
    end
endgenerate

// Final adder
adder_2to1 a2a1_final (
    .a(level4_count[0]),
    .b(level4_count[1]),
    .out(count)
);

assign out = count;

endmodule

module bit_sliced_counter (
    input  [7:0] in,
    output [7:0] out
);

reg [7:0] count;
always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 8; i++) begin
        if (in[i]) begin
            count = count + 1;
        end
    end
end
assign out = count;

endmodule

module adder_2to1 (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

assign out = a + b;

endmodule