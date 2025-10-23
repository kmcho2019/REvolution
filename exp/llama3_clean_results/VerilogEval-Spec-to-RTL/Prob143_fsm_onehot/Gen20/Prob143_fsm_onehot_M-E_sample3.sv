module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        case ({in, state})
            // S0
            {1'b0, 10'b1}: begin next_state_reg[0] = 1'b1; end
            {1'b1, 10'b1}: begin next_state_reg[1] = 1'b1; end
            // S1
            {1'b0, 10'b10}: begin next_state_reg[0] = 1'b1; end
            {1'b1, 10'b10}: begin next_state_reg[2] = 1'b1; end
            // S2
            {1'b0, 10'b100}: begin next_state_reg[0] = 1'b1; end
            {1'b1, 10'b100}: begin next_state_reg[3] = 1'b1; end
            // S3
            {1'b0, 10'b1000}: begin next_state_reg[0] = 1'b1; end
            {1'b1, 10'b1000}: begin next_state_reg[4] = 1'b1; end
            // S4
            {1'b0, 10'b10000}: begin next_state_reg[0] = 1'b1; end
            {1'b1, 10'b10000}: begin next_state_reg[5] = 1'b1; end
            // S5
            {1'b0, 10'b100000}: begin next_state_reg[8] = 1'b1; end
            {1'b1, 10'b100000}: begin next_state_reg[6] = 1'b1; end
            // S6
            {1'b0, 10'b1000000}: begin next_state_reg[9] = 1'b1; end
            {1'b1, 10'b1000000}: begin next_state_reg[7] = 1'b1; end
            // S7
            {1'b0, 10'b10000000}: begin next_state_reg[0] = 1'b1; out2_reg = 1'b1; end
            {1'b1, 10'b10000000}: begin next_state_reg[7] = 1'b1; out2_reg = 1'b1; end
            // S8
            {1'b0, 10'b100000000}: begin next_state_reg[0] = 1'b1; out1_reg = 1'b1; end
            {1'b1, 10'b100000000}: begin next_state_reg[1] = 1'b1; out1_reg = 1'b1; end
            // S9
            {1'b0, 10'b1000000000}: begin next_state_reg[0] = 1'b1; out1_reg = 1'b1; out2_reg = 1'b1; end
            {1'b1, 10'b1000000000}: begin next_state_reg[1] = 1'b1; out1_reg = 1'b1; out2_reg = 1'b1; end
            default: begin
                for (int i = 0; i < 10; i++) begin
                    if (state[i]) begin
                        case (i)
                            0: begin
                                if (!in) next_state_reg[0] = 1'b1;
                                else next_state_reg[1] = 1'b1;
                            end
                            1: begin
                                if (!in) next_state_reg[0] = 1'b1;
                                else next_state_reg[2] = 1'b1;
                            end
                            2: begin
                                if (!in) next_state_reg[0] = 1'b1;
                                else next_state_reg[3] = 1'b1;
                            end
                            3: begin
                                if (!in) next_state_reg[0] = 1'b1;
                                else next_state_reg[4] = 1'b1;
                            end
                            4: begin
                                if (!in) next_state_reg[0] = 1'b1;
                                else next_state_reg[5] = 1'b1;
                            end
                            5: begin
                                if (!in) next_state_reg[8] = 1'b1;
                                else next_state_reg[6] = 1'b1;
                            end
                            6: begin
                                if (!in) next_state_reg[9] = 1'b1;
                                else next_state_reg[7] = 1'b1;
                            end
                            7: begin
                                if (!in) begin
                                    next_state_reg[0] = 1'b1;
                                    out2_reg = 1'b1;
                                end
                                else begin
                                    next_state_reg[7] = 1'b1;
                                    out2_reg = 1'b1;
                                end
                            end
                            8: begin
                                if (!in) begin
                                    next_state_reg[0] = 1'b1;
                                    out1_reg = 1'b1;
                                end
                                else begin
                                    next_state_reg[1] = 1'b1;
                                    out1_reg = 1'b1;
                                end
                            end
                            9: begin
                                if (!in) begin
                                    next_state_reg[0] = 1'b1;
                                    out1_reg = 1'b1;
                                    out2_reg = 1'b1;
                                end
                                else begin
                                    next_state_reg[1] = 1'b1;
                                    out1_reg = 1'b1;
                                    out2_reg = 1'b1;
                                end
                            end
                        endcase
                    end
                end
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule