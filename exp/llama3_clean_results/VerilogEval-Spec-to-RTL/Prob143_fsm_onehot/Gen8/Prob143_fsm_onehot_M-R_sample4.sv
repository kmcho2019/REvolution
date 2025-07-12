module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    always @(*) begin
        case (1'b1)
            state[0]: // S0
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b10;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[1]: // S1
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b100;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[2]: // S2
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b1000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[3]: // S3
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b10000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[4]: // S4
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b100000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[5]: // S5
                if (!in) begin
                    next_state = 10'b100000000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b1000000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[6]: // S6
                if (!in) begin
                    next_state = 10'b1000000000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b10000000;
                    out1 = 1'b0;
                    out2 = 1'b0;
                end
            state[7]: // S7
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b0;
                    out2 = 1'b1;
                end else begin
                    next_state = 10'b10000000;
                    out1 = 1'b0;
                    out2 = 1'b1;
                end
            state[8]: // S8
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b1;
                    out2 = 1'b0;
                end else begin
                    next_state = 10'b10;
                    out1 = 1'b1;
                    out2 = 1'b0;
                end
            state[9]: // S9
                if (!in) begin
                    next_state = 10'b1;
                    out1 = 1'b1;
                    out2 = 1'b1;
                end else begin
                    next_state = 10'b10;
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
        endcase
    end

endmodule