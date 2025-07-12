module popcount4 (
    input  [3:0] in,
    output [2:0] out // max count 4 -> 3 bits enough
);
    // Sum bits explicitly
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [2:0] total = sum01 + sum23;
    assign out = total;
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones, needs 5 bits, use 6 for safety
);
    // Four popcount4 blocks plus one leftover bit
    wire [2:0] pc0, pc1, pc2, pc3;

    popcount4 pc_0 (.in(in[3:0]),    .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),    .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),   .out(pc2));
    popcount4 pc_3 (.in(in[15:12]),  .out(pc3));

    // Sum pairs of pc4 results (3 bits + 3 bits = 4 bits max sum)
    wire [4:0] sum01 = pc0 + pc1; // max 8 fits in 4 bits, use 5 for safety
    wire [4:0] sum23 = pc2 + pc3;

    // Sum sum01 and sum23 (5 bits + 5 bits = 6 bits max 16)
    wire [5:0] sum0123 = sum01 + sum23;

    // Add leftover bit in[16]
    assign out = sum0123 + in[16];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Instantiate 15 popcount17 modules for 15*17 = 255 bits
    wire [5:0] partial_counts [14:0];

    popcount17 pc0  (.in(in[ 16:  0]), .out(partial_counts[0]));
    popcount17 pc1  (.in(in[ 33: 17]), .out(partial_counts[1]));
    popcount17 pc2  (.in(in[ 50: 34]), .out(partial_counts[2]));
    popcount17 pc3  (.in(in[ 67: 51]), .out(partial_counts[3]));
    popcount17 pc4  (.in(in[ 84: 68]), .out(partial_counts[4]));
    popcount17 pc5  (.in(in[101: 85]), .out(partial_counts[5]));
    popcount17 pc6  (.in(in[118:102]), .out(partial_counts[6]));
    popcount17 pc7  (.in(in[135:119]), .out(partial_counts[7]));
    popcount17 pc8  (.in(in[152:136]), .out(partial_counts[8]));
    popcount17 pc9  (.in(in[169:153]), .out(partial_counts[9]));
    popcount17 pc10 (.in(in[186:170]), .out(partial_counts[10]));
    popcount17 pc11 (.in(in[203:187]), .out(partial_counts[11]));
    popcount17 pc12 (.in(in[220:204]), .out(partial_counts[12]));
    popcount17 pc13 (.in(in[237:221]), .out(partial_counts[13]));
    popcount17 pc14 (.in(in[254:238]), .out(partial_counts[14]));

    // Balanced adder tree to sum the 15 partial_counts (6 bits each)
    // Use 8-bit wires for sums to avoid overflow (max total = 255)
    // Level 1: sum pairs of partial_counts (7 pairs) + one leftover partial_count
    wire [7:0] sumL1_0 = partial_counts[0] + partial_counts[1];
    wire [7:0] sumL1_1 = partial_counts[2] + partial_counts[3];
    wire [7:0] sumL1_2 = partial_counts[4] + partial_counts[5];
    wire [7:0] sumL1_3 = partial_counts[6] + partial_counts[7];
    wire [7:0] sumL1_4 = partial_counts[8] + partial_counts[9];
    wire [7:0] sumL1_5 = partial_counts[10] + partial_counts[11];
    wire [7:0] sumL1_6 = partial_counts[12] + partial_counts[13];
    wire [7:0] sumL1_7 = {2'b00, partial_counts[14]}; // leftover zero-extended

    // Level 2: sum pairs of Level 1 outputs
    wire [7:0] sumL2_0 = sumL1_0 + sumL1_1;
    wire [7:0] sumL2_1 = sumL1_2 + sumL1_3;
    wire [7:0] sumL2_2 = sumL1_4 + sumL1_5;
    wire [7:0] sumL2_3 = sumL1_6 + sumL1_7;

    // Level 3: sum pairs of Level 2 outputs
    wire [7:0] sumL3_0 = sumL2_0 + sumL2_1;
    wire [7:0] sumL3_1 = sumL2_2 + sumL2_3;

    // Level 4: final sum of the last two sums
    assign out = sumL3_0 + sumL3_1;

endmodule