module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define next states for in=0 and in=1 per state index (0 to 9)
    // Using localparams for clarity and compactness
    localparam [9:0] NEXT_0 [0:9] = {
        10'b0000000001, // S0 on in=0 -> S0
        10'b0000000001, // S1 on in=0 -> S0
        10'b0000000001, // S2 on in=0 -> S0
        10'b0000000001, // S3 on in=0 -> S0
        10'b0000000001, // S4 on in=0 -> S0
        10'b0000010000, // S5 on in=0 -> S8 (bit 8)
        10'b0000100000, // S6 on in=0 -> S9 (bit 9)
        10'b0000000001, // S7 on in=0 -> S0
        10'b0000000001, // S8 on in=0 -> S0
        10'b0000000001  // S9 on in=0 -> S0
    };

    localparam [9:0] NEXT_1 [0:9] = {
        10'b0000000010, // S0 on in=1 -> S1
        10'b0000000100, // S1 on in=1 -> S2
        10'b0000001000, // S2 on in=1 -> S3
        10'b0000010000, // S3 on in=1 -> S4
        10'b0000100000, // S4 on in=1 -> S5
        10'b0001000000, // S5 on in=1 -> S6
        10'b0010000000, // S6 on in=1 -> S7
        10'b1000000000, // S7 on in=1 -> S7
        10'b0000000010, // S8 on in=1 -> S1
        10'b0000000010  // S9 on in=1 -> S1
    };

    reg [9:0] ns_agg;

    integer i;
    always @(*) begin
        ns_agg = 10'b0;
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                if (in)
                    ns_agg = ns_agg | NEXT_1[i];
                else
                    ns_agg = ns_agg | NEXT_0[i];
            end
        end
    end

    assign next_state = ns_agg;

    // Outputs:
    // out1 = 1 if state 8 or 9 active (since S8=(1,0), S9=(1,1))
    // out2 = 1 if state 7 or 9 active (S7=(0,1), S9=(1,1))
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule