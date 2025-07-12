module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state;
    reg out1, out2;

    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        for (int i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    0: if (in) next_state[1] = 1'b1; else next_state[0] = 1'b1;
                    1: if (in) next_state[2] = 1'b1; else next_state[0] = 1'b1;
                    2: if (in) next_state[3] = 1'b1; else next_state[0] = 1'b1;
                    3: if (in) next_state[4] = 1'b1; else next_state[0] = 1'b1;
                    4: if (in) next_state[5] = 1'b1; else next_state[0] = 1'b1;
                    5: if (in) next_state[6] = 1'b1; else next_state[8] = 1'b1;
                    6: if (in) next_state[7] = 1'b1; else next_state[9] = 1'b1;
                    7: if (in) next_state[7] = 1'b1; else next_state[0] = 1'b1;
                    8: if (in) next_state[1] = 1'b1; else next_state[0] = 1'b1;
                    9: if (in) next_state[1] = 1'b1; else next_state[0] = 1'b1;
                endcase
            end
        end

        if (state[7]) begin
            out1 = 1'b0;
            out2 = 1'b1;
        end
        if (state[8]) begin
            out1 = 1'b1;
            out2 = 1'b0;
        end
        if (state[9]) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule