module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    // Localparams for output masks (states producing outputs)
    localparam [9:0] OUT1_MASK = 10'b1100000000; // S8, S9
    localparam [9:0] OUT2_MASK = (1 << 7) | (1 << 9); // S7, S9

    integer i;

    always @* begin
        next_state = 10'b0;  // Default no next states active

        // For each active state bit, determine next state(s) based on input
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: next_state[in ? 1 : 0] = 1'b1; // S0: 0->S0, 1->S1
                    1: next_state[in ? 2 : 0] = 1'b1; // S1: 0->S0, 1->S2
                    2: next_state[in ? 3 : 0] = 1'b1; // S2: 0->S0, 1->S3
                    3: next_state[in ? 4 : 0] = 1'b1; // S3: 0->S0, 1->S4
                    4: next_state[in ? 5 : 0] = 1'b1; // S4: 0->S0, 1->S5
                    5: next_state[in ? 6 : 8] = 1'b1; // S5: 0->S8, 1->S6
                    6: next_state[in ? 7 : 9] = 1'b1; // S6: 0->S9, 1->S7
                    7: next_state[in ? 7 : 0] = 1'b1; // S7: 0->S0, 1->S7
                    8: next_state[in ? 1 : 0] = 1'b1; // S8: 0->S0, 1->S1
                    9: next_state[in ? 1 : 0] = 1'b1; // S9: 0->S0, 1->S1
                    default: /* no next state */;
                endcase
            end
        end
    end

    // Outputs active if any active state in their respective masks
    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK);

endmodule