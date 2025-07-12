module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output        out1,
    output        out2
);

    integer i;

    always @(*) begin
        // Initialize next_state to zero
        next_state = 10'b0;

        // For each active state bit, set corresponding next state(s)
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: next_state[in ? 1 : 0] = 1'b1;  // S0
                    1: next_state[in ? 2 : 0] = 1'b1;  // S1
                    2: next_state[in ? 3 : 0] = 1'b1;  // S2
                    3: next_state[in ? 4 : 0] = 1'b1;  // S3
                    4: next_state[in ? 5 : 0] = 1'b1;  // S4
                    5: next_state[in ? 6 : 8] = 1'b1;  // S5
                    6: next_state[in ? 7 : 9] = 1'b1;  // S6
                    7: next_state[in ? 7 : 0] = 1'b1;  // S7
                    8: next_state[in ? 1 : 0] = 1'b1;  // S8
                    9: next_state[in ? 1 : 0] = 1'b1;  // S9
                    default: /* no transition */;
                endcase
            end
        end
    end

    // Output logic: out1 and out2 are combinational outputs driven by current states
    // out1 asserted when S8 or S9 is active
    // out2 asserted when S7 or S9 is active
    localparam [9:0] OUT1_MASK = 10'b1100000000; // bits 9 (S9) and 8 (S8)
    localparam [9:0] OUT2_MASK = 10'b0100000000; // bits 9 (S9) and 7 (S7), corrected mask below

    // Correct masks: 
    // S9 is bit 9, S8 is bit 8, S7 is bit 7
    // OUT1_MASK = bits 9 and 8 -> 10'b1100000000 (bits 9 and 8 set)
    // OUT2_MASK = bits 9 and 7 -> 10'b0100000000 with bits 7 and 9 set => 10'b1010000000
    
    // Let's fix OUT2_MASK:
    localparam [9:0] OUT2_MASK_CORRECT = (1 << 7) | (1 << 9);

    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK_CORRECT);

endmodule