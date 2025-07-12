module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // For each bit, compute greater, less, and equal signals
    wire [3:0] bit_greater;
    wire [3:0] bit_less;
    wire [3:0] bit_equal;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : bit_compare
            assign bit_greater[i] =  A[i] & (~B[i]);
            assign bit_less[i]    = (~A[i]) & B[i];
            assign bit_equal[i]   = ~(bit_greater[i] | bit_less[i]);
        end
    endgenerate

    // Determine where bits differ, starting from MSB
    wire [3:0] greater_priority;
    wire [3:0] less_priority;

    // Priority from MSB down to LSB to find first differing bit
    assign greater_priority[3] = bit_greater[3];
    assign less_priority[3]    = bit_less[3];

    assign greater_priority[2] = bit_equal[3] & bit_greater[2];
    assign less_priority[2]    = bit_equal[3] & bit_less[2];

    assign greater_priority[1] = bit_equal[3] & bit_equal[2] & bit_greater[1];
    assign less_priority[1]    = bit_equal[3] & bit_equal[2] & bit_less[1];

    assign greater_priority[0] = bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_greater[0];
    assign less_priority[0]    = bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_less[0];

    // Combine signals to get overall comparison result
    assign A_greater = |greater_priority;
    assign A_less    = |less_priority;
    assign A_equal   = ~(A_greater | A_less); // If neither greater nor less, then equal

endmodule