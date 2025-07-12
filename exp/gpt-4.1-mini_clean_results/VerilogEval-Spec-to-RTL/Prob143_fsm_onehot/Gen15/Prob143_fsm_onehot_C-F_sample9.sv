module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    // Output masks defining states that assert outputs
    localparam [9:0] OUT1_MASK = (1 << 8) | (1 << 9); // S8, S9 produce out1=1
    localparam [9:0] OUT2_MASK = (1 << 7) | (1 << 9); // S7, S9 produce out2=1

    integer i;

    always @* begin
        next_state = 10'b0;

        // For each active state bit, determine next state(s) based on input
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: next_state[in ? 1 : 0] = 1'b1;  // S0: in=0->S0, in=1->S1
                    1: next_state[in ? 2 : 0] = 1'b1;  // S1: in=0->S0, in=1->S2
                    2: next_state[in ? 3 : 0] = 1'b1;  // S2: in=0->S0, in=1->S3
                    3: next_state[in ? 4 : 0] = 1'b1;  // S3: in=0->S0, in=1->S4
                    4: next_state[in ? 5 : 0] = 1'b1;  // S4: in=0->S0, in=1->S5
                    5: next_state[in ? 6 : 8] = 1'b1;  // S5: in=0->S8, in=1->S6
                    6: next_state[in ? 7 : 9] = 1'b1;  // S6: in=0->S9, in=1->S7
                    7: next_state[in ? 7 : 0] = 1'b1;  // S7: in=0->S0, in=1->S7
                    8: next_state[in ? 1 : 0] = 1'b1;  // S8: in=0->S0, in=1->S1
                    9: next_state[in ? 1 : 0] = 1'b1;  // S9: in=0->S0, in=1->S1
                    default: ; // No next state
                endcase
            end
        end
    end

    // Outputs asserted if any active current state in their respective masks
    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK);

endmodule