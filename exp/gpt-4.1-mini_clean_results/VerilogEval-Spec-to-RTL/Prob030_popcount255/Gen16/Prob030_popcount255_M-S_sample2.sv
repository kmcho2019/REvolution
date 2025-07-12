module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);
    // Partition input into 31 full 8-bit groups and 1 group of 7 bits
    wire [3:0] partial_counts [31:0];

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : popcount8_blocks
            popcount8 u_popcount8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Last group: 7 bits zero-padded to 8 bits
    wire [7:0] last_chunk = {1'b0, in[248 +: 7]};
    popcount8 u_popcount8_last (
        .in(last_chunk),
        .out(partial_counts[31])
    );

    integer idx;
    reg [15:0] sum;
    always @(*) begin
        sum = 0;
        for (idx = 0; idx < 32; idx = idx + 1) begin
            sum = sum + partial_counts[idx];
        end
        out = sum[7:0]; // max 255 fits in 8 bits
    end
endmodule