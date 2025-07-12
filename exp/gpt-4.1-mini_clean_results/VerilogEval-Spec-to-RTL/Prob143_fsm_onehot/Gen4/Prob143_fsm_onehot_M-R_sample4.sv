module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

    integer i;
    always @(*) begin
        // Initialize outputs
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // For each possible active state, accumulate transitions and outputs
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: begin
                        if (in) next_state[1] = 1'b1; else next_state[0] = 1'b1;
                    end
                    1: begin
                        if (in) next_state[2] = 1'b1; else next_state[0] = 1'b1;
                    end
                    2: begin
                        if (in) next_state[3] = 1'b1; else next_state[0] = 1'b1;
                    end
                    3: begin
                        if (in) next_state[4] = 1'b1; else next_state[0] = 1'b1;
                    end
                    4: begin
                        if (in) next_state[5] = 1'b1; else next_state[0] = 1'b1;
                    end
                    5: begin
                        if (in) next_state[6] = 1'b1; else next_state[8] = 1'b1;
                    end
                    6: begin
                        if (in) next_state[7] = 1'b1; else next_state[9] = 1'b1;
                    end
                    7: begin
                        if (in) next_state[7] = 1'b1; else next_state[0] = 1'b1;
                        out1 = out1 | 1'b0; // out1=0 (explicit)
                        out2 = out2 | 1'b1;
                    end
                    8: begin
                        if (in) next_state[1] = 1'b1; else next_state[0] = 1'b1;
                        out1 = out1 | 1'b1;
                        out2 = out2 | 1'b0;
                    end
                    9: begin
                        if (in) next_state[1] = 1'b1; else next_state[0] = 1'b1;
                        out1 = out1 | 1'b1;
                        out2 = out2 | 1'b1;
                    end
                    default: begin
                        // No transitions, no outputs
                    end
                endcase
            end
        end
    end

endmodule