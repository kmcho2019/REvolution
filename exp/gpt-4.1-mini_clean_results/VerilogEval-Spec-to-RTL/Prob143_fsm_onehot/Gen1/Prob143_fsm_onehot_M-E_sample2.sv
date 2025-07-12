module TopModule (
    input  wire        in,
    input  wire [9:0]  state,
    output reg  [9:0]  next_state,
    output reg         out1,
    output reg         out2
);

    // Encode outputs for each state: out1_array and out2_array
    // Index: state number 0..9
    wire [9:0] out1_array = 10'b0000001100; // S8 and S9 have out1=1
    wire [9:0] out2_array = 10'b1000000010; // S7 and S9 have out2=1

    // Define next state for input=0 and input=1 for each state
    // The next_state for input=0 and input=1 are stored as one-hot 10-bit vectors

    // next_state_if_0[state_index] = next state when input=0
    localparam [9:0] next_state_if_0 [0:9] = {
        10'b0000000001, // S0(0) --0--> S0 (bit 0)
        10'b0000000001, // S1(1) --0--> S0
        10'b0000000001, // S2(2) --0--> S0
        10'b0000000001, // S3(3) --0--> S0
        10'b0000000001, // S4(4) --0--> S0
        10'b0010000000, // S5(5) --0--> S8 (bit 8)
        10'b0100000000, // S6(6) --0--> S9 (bit 9)
        10'b0000000001, // S7(7) --0--> S0
        10'b0000000001, // S8(8) --0--> S0
        10'b0000000001  // S9(9) --0--> S0
    };

    // next_state_if_1[state_index] = next state when input=1
    localparam [9:0] next_state_if_1 [0:9] = {
        10'b0000000010, // S0(0) --1--> S1 (bit 1)
        10'b0000000100, // S1(1) --1--> S2 (bit 2)
        10'b0000001000, // S2(2) --1--> S3 (bit 3)
        10'b0000010000, // S3(3) --1--> S4 (bit 4)
        10'b0000100000, // S4(4) --1--> S5 (bit 5)
        10'b0001000000, // S5(5) --1--> S6 (bit 6)
        10'b1000000000, // S6(6) --1--> S7 (bit 7)
        10'b1000000000, // S7(7) --1--> S7 (bit 7)
        10'b0000000010, // S8(8) --1--> S1 (bit 1)
        10'b0000000010  // S9(9) --1--> S1 (bit 1)
    };

    integer i;

    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                // Accumulate next_state bits based on input
                if (in == 1'b0)
                    next_state = next_state | next_state_if_0[i];
                else
                    next_state = next_state | next_state_if_1[i];

                // Accumulate outputs
                out1 = out1 | out1_array[i];
                out2 = out2 | out2_array[i];
            end
        end
    end

endmodule