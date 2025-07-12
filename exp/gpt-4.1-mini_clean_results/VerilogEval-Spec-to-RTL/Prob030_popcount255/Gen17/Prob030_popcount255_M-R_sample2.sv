module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits for sum up to 17
);
    // Level 1: sum pairs of bits (2-bit results)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit values (3-bit results)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit values (4-bit results)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit values (5-bit result)
    wire [4:0] s14 = s12 + s13;

    // Add leftover bit, final 6-bit output
    assign out = s14 + leftover;

endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate 15 popcount17 modules for input partitions
    wire [5:0] partial_counts [0:14];

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : popcount17_blocks
            popcount17 pc17 (
                .in(in[i*17 +: 17]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Iteratively sum all partial counts in combinational logic
    // Use a reg because we will sum in a combinational always block
    reg [7:0] sum; // 8 bits enough for max sum 255

    integer idx;
    always @(*) begin
        sum = 0;
        for (idx = 0; idx < 15; idx = idx + 1) begin
            sum = sum + partial_counts[idx];
        end
    end

    assign out = sum;

endmodule