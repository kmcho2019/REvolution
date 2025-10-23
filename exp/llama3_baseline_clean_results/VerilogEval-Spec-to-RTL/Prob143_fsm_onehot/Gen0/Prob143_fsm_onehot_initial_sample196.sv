module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = 10'b0000000000;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    always @(*) begin
        case({state, in})
            // S0
            10'b0000000001, 10'b1000000001: begin
                if (in) next_state[1] = 1'b1;
                else next_state[0] = 1'b1;
            end
            // S1
            10'b0000000010, 10'b1000000010: begin
                if (in) next_state[2] = 1'b1;
                else next_state[0] = 1'b1;
            end
            // S2
            10'b0000000100, 10'b1000000100: begin
                if (in) next_state[3] = 1'b1;
                else next_state[0] = 1'b1;
            end
            // S3
            10'b0000001000, 10'b1000001000: begin
                if (in) next_state[4] = 1'b1;
                else next_state[0] = 1'b1;
            end
            // S4
            10'b0000010000, 10'b1000010000: begin
                if (in) next_state[5] = 1'b1;
                else next_state[0] = 1'b1;
            end
            // S5
            10'b0000100000, 10'b1000100000: begin
                if (in) next_state[6] = 1'b1;
                else next_state[8] = 1'b1;
            end
            // S6
            10'b0001000000, 10'b1001000000: begin
                if (in) next_state[7] = 1'b1;
                else next_state[9] = 1'b1;
            end
            // S7
            10'b0010000000, 10'b1010000000: begin
                if (in) next_state[7] = 1'b1;
                else next_state[0] = 1'b1;
                out2 = 1'b1;
            end
            // S8
            10'b0100000000, 10'b1100000000: begin
                if (in) next_state[1] = 1'b1;
                else next_state[0] = 1'b1;
                out1 = 1'b1;
            end
            // S9
            10'b1000000000, 10'b1000000000: begin
                if (in) next_state[1] = 1'b1;
                else next_state[0] = 1'b1;
                out1 = 1'b1;
                out2 = 1'b1;
            end
            default: begin
                next_state[0] = 1'b1;
            end
        endcase
    end
endmodule