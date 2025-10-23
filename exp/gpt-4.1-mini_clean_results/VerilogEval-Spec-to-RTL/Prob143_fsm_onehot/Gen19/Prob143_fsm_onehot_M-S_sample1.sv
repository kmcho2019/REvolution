module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Transition matrices for in=0 and in=1
    // Each element corresponds to possible next states when current state is active
    // Rows = current states S0..S9
    // Columns = next states S0..S9
    // 1 bit per next state

    localparam [9:0] trans0 [0:9] = {
        10'b0000000001, // S0 --0--> S0
        10'b0000000001, // S1 --0--> S0
        10'b0000000001, // S2 --0--> S0
        10'b0000000001, // S3 --0--> S0
        10'b0000000001, // S4 --0--> S0
        10'b0001000000, // S5 --0--> S8
        10'b0010000000, // S6 --0--> S9
        10'b0000000001, // S7 --0--> S0
        10'b0000000001, // S8 --0--> S0
        10'b0000000001  // S9 --0--> S0
    };

    localparam [9:0] trans1 [0:9] = {
        10'b0000000010, // S0 --1--> S1
        10'b0000000100, // S1 --1--> S2
        10'b0000001000, // S2 --1--> S3
        10'b0000010000, // S3 --1--> S4
        10'b0000100000, // S4 --1--> S5
        10'b0001000000, // S5 --1--> S6
        10'b0010000000, // S6 --1--> S7
        10'b1000000000, // S7 --1--> S7 (bit9=1 is S9, so bit7=1 is S7)
                        // Correction: According to the spec, S7 --1--> S7 (self-loop), so next state is S7 (bit7)
                        // So corrected bit pattern for S7 is bit7=1
        10'b0000000010, // S8 --1--> S1
        10'b0000000010  // S9 --1--> S1
    };

    // Correct S7 transition for in=1: next_state = S7 (bit7=1)
    // So update trans1[7] = 10'b0000000000_10000000; bit7=1
    // Let's fix trans1 array now:

    localparam [9:0] trans1_fixed [0:9] = {
        10'b0000000010, // S0 --1--> S1
        10'b0000000100, // S1 --1--> S2
        10'b0000001000, // S2 --1--> S3
        10'b0000010000, // S3 --1--> S4
        10'b0000100000, // S4 --1--> S5
        10'b0001000000, // S5 --1--> S6
        10'b0010000000, // S6 --1--> S7
        10'b00000010000000, // Invalid width (too many bits)
    };

    // We must write 10 bits for each element, bit7 corresponds to S7, bit7=1 << 7 = 8'h80 = 10'b0000001000 0000
    // But that is more than 10 bits (it's 13 bits)

    // Let's represent 10 bits as: bit0 = S0 ... bit7 = S7 ... bit9 = S9
    // 10 bits: bit0 .. bit9
    // bit7 = (1 << 7) = 128 decimal = 10'b0010000000

    // So S7 --1--> S7 means trans1[7] = 10'b0010000000;

    // Re-define trans1 with correction:

    localparam [9:0] trans1_final [0:9] = {
        10'b0000000010, // S0 --1--> S1 (bit1)
        10'b0000000100, // S1 --1--> S2 (bit2)
        10'b0000001000, // S2 --1--> S3 (bit3)
        10'b0000010000, // S3 --1--> S4 (bit4)
        10'b0000100000, // S4 --1--> S5 (bit5)
        10'b0001000000, // S5 --1--> S6 (bit6)
        10'b0010000000, // S6 --1--> S7 (bit7)
        10'b0010000000, // S7 --1--> S7 (bit7)
        10'b0000000010, // S8 --1--> S1 (bit1)
        10'b0000000010  // S9 --1--> S1 (bit1)
    };

    integer i;
    reg [9:0] next0, next1;

    always @(*) begin
        next0 = 10'b0;
        next1 = 10'b0;
        for (i=0; i<10; i=i+1) begin
            if (state[i]) begin
                next0 = next0 | trans0[i];
                next1 = next1 | trans1_final[i];
            end
        end
    end

    assign next_state = in ? next1 : next0;

    // Outputs: out1 = 1 if state includes S8 or S9; out2 = 1 if state includes S7 or S9

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule