module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    integer idx;
    wire in0 = ~in;
    wire in1 =  in;

    always @* begin
        next_state = 10'b0;

        // Accumulate next_state bits for all active states
        for (idx = 0; idx < 10; idx = idx + 1) begin
            if (state[idx]) begin
                case (idx)
                    0: begin
                        // S0: in=0->S0, in=1->S1
                        next_state[0] = next_state[0] | in0;
                        next_state[1] = next_state[1] | in1;
                    end
                    1: begin
                        // S1: in=0->S0, in=1->S2
                        next_state[0] = next_state[0] | in0;
                        next_state[2] = next_state[2] | in1;
                    end
                    2: begin
                        // S2: in=0->S0, in=1->S3
                        next_state[0] = next_state[0] | in0;
                        next_state[3] = next_state[3] | in1;
                    end
                    3: begin
                        // S3: in=0->S0, in=1->S4
                        next_state[0] = next_state[0] | in0;
                        next_state[4] = next_state[4] | in1;
                    end
                    4: begin
                        // S4: in=0->S0, in=1->S5
                        next_state[0] = next_state[0] | in0;
                        next_state[5] = next_state[5] | in1;
                    end
                    5: begin
                        // S5: in=0->S8, in=1->S6
                        next_state[8] = next_state[8] | in0;
                        next_state[6] = next_state[6] | in1;
                    end
                    6: begin
                        // S6: in=0->S9, in=1->S7
                        next_state[9] = next_state[9] | in0;
                        next_state[7] = next_state[7] | in1;
                    end
                    7: begin
                        // S7: in=0->S0, in=1->S7
                        next_state[0] = next_state[0] | in0;
                        next_state[7] = next_state[7] | in1;
                    end
                    8: begin
                        // S8: in=0->S0, in=1->S1
                        next_state[0] = next_state[0] | in0;
                        next_state[1] = next_state[1] | in1;
                    end
                    9: begin
                        // S9: in=0->S0, in=1->S1
                        next_state[0] = next_state[0] | in0;
                        next_state[1] = next_state[1] | in1;
                    end
                    default: ; // Should not occur
                endcase
            end
        end
    end

    // Outputs depend only on current active states
    // out1 = state[8] or state[9]
    // out2 = state[7] or state[9]
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule