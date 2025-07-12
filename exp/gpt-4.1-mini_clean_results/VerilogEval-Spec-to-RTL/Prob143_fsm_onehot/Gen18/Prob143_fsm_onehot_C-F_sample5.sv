module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    integer i;

    always @* begin
        next_state = 10'b0; // default clear

        // For each active current state, set corresponding next_state bits
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: next_state[in ? 1 : 0] = 1'b1;   // S0: in=0->S0, in=1->S1
                    1: next_state[in ? 2 : 0] = 1'b1;   // S1: in=0->S0, in=1->S2
                    2: next_state[in ? 3 : 0] = 1'b1;   // S2: in=0->S0, in=1->S3
                    3: next_state[in ? 4 : 0] = 1'b1;   // S3: in=0->S0, in=1->S4
                    4: next_state[in ? 5 : 0] = 1'b1;   // S4: in=0->S0, in=1->S5
                    5: next_state[in ? 6 : 8] = 1'b1;   // S5: in=0->S8, in=1->S6
                    6: next_state[in ? 7 : 9] = 1'b1;   // S6: in=0->S9, in=1->S7
                    7: next_state[in ? 7 : 0] = 1'b1;   // S7: in=0->S0, in=1->S7
                    8: next_state[in ? 1 : 0] = 1'b1;   // S8: in=0->S0, in=1->S1
                    9: next_state[in ? 1 : 0] = 1'b1;   // S9: in=0->S0, in=1->S1
                    default: ;
                endcase
            end
        end
    end

    // Outputs depend only on the current state bits (not input)
    // out1 = 1 if S8 or S9 active
    // out2 = 1 if S7 or S9 active

    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9); // bits 8 and 9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9); // bits 7 and 9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule