module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define next state vectors for input=0 and input=1 for each state S0-S9
    // Each entry is a 10-bit one-hot vector representing next state for that input
    localparam [9:0] NEXT0 [0:9] = {
        10'b0000000001, // S0 --0--> S0
        10'b0000000001, // S1 --0--> S0
        10'b0000000001, // S2 --0--> S0
        10'b0000000001, // S3 --0--> S0
        10'b0000000001, // S4 --0--> S0
        10'b1000000000, // S5 --0--> S8
        10'b0100000000, // S6 --0--> S9
        10'b0000000001, // S7 --0--> S0
        10'b0000000001, // S8 --0--> S0
        10'b0000000001  // S9 --0--> S0
    };

    localparam [9:0] NEXT1 [0:9] = {
        10'b0000000010, // S0 --1--> S1
        10'b0000000100, // S1 --1--> S2
        10'b0000001000, // S2 --1--> S3
        10'b0000010000, // S3 --1--> S4
        10'b0000100000, // S4 --1--> S5
        10'b0000010000, // S5 --1--> S6
        10'b0000001000, // S6 --1--> S7
        10'b0000001000, // S7 --1--> S7
        10'b0000000010, // S8 --1--> S1
        10'b0000000010  // S9 --1--> S1
    };

    // Initialize next_state accumulator
    integer i;
    reg [9:0] next_state_reg;
    always @(*) begin
        next_state_reg = 10'b0;
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                if (in)
                    next_state_reg = next_state_reg | NEXT1[i];
                else
                    next_state_reg = next_state_reg | NEXT0[i];
            end
        end
    end

    assign next_state = next_state_reg;

    // Output logic:
    // S7 -> (out1=0, out2=1)
    // S8 -> (out1=1, out2=0)
    // S9 -> (out1=1, out2=1)
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule