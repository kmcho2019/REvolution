module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    wire [2:0] sum_lo = in[0] + in[1] + in[2] + in[3];
    wire [2:0] sum_hi = in[4] + in[5] + in[6] + in[7];
    assign out = sum_lo + sum_hi;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // We have 16 groups; last group is 15 bits + 1 pad bit
    // Each group is 16 bits split into two 8-bit for popcount8

    // Arrays for intermediate signals
    wire [3:0] pc8_l [0:15];
    wire [3:0] pc8_h [0:15];
    wire [4:0] pc16  [0:15]; // sum of two popcount8 outputs

    // Pad last 15-bit group with a zero MSB to make 16 bits
    wire [15:0] groups [0:15];

    // Generate groups by slicing input and padding last group
    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : group_assign
            assign groups[i] = in[(16*i+15) : (16*i)];
        end
        // Last group: in[254:240] plus one 0 bit at MSB
        assign groups[15] = {1'b0, in[254:240]};
    endgenerate

    // Instantiate popcount8 modules for each group's lower and upper 8 bits
    generate
        for (i = 0; i < 16; i = i + 1) begin : pc8_instances
            popcount8 pc_l (.in(groups[i][7:0]),  .out(pc8_l[i]));
            popcount8 pc_h (.in(groups[i][15:8]), .out(pc8_h[i]));
            assign pc16[i] = pc8_l[i] + pc8_h[i]; // 5-bit output (max 16)
        end
    endgenerate

    // Function to sum an array of 5-bit values in a balanced binary tree manner
    function [7:0] sum_5bit_array;
        input [4:0] arr [0:15];
        integer idx;
        reg [6:0] sum_l2 [0:7];
        reg [7:0] sum_l3 [0:3];
        reg [8:0] sum_l4 [0:1];
        reg [8:0] sum_final;
    begin
        // Level 1: sum pairs of 5-bit values -> 6-bit sums
        for (idx = 0; idx < 8; idx = idx + 1)
            sum_l2[idx] = arr[2*idx] + arr[2*idx+1];
        // Level 2: sum pairs of 6-bit values -> 7-bit sums
        for (idx = 0; idx < 4; idx = idx + 1)
            sum_l3[idx] = sum_l2[2*idx] + sum_l2[2*idx+1];
        // Level 3: sum pairs of 7-bit values -> 8-bit sums
        for (idx = 0; idx < 2; idx = idx + 1)
            sum_l4[idx] = sum_l3[2*idx] + sum_l3[2*idx+1];
        // Level 4: sum final two 8-bit sums -> 9-bit sum
        sum_final = sum_l4[0] + sum_l4[1];
        // Output limited to 8 bits since max count is 255 (8 bits sufficient)
        sum_5bit_array = sum_final[7:0];
    end
    endfunction

    // Assign the final output as the sum of all group counts
    assign out = sum_5bit_array(pc16);

endmodule