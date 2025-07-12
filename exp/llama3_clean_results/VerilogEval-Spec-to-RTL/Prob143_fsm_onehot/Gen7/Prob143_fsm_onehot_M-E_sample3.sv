module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define internal signals for state transitions and outputs
    wire [9:0] next_state_int;
    wire out1_int;
    wire out2_int;

    // Module for states S0 to S4
    module States0_4(
        input in,
        input [4:0] state,
        output [4:0] next_state,
        output out1,
        output out2
    );
        reg [4:0] next_state_reg;
        reg out1_reg;
        reg out2_reg;

        always @(*) begin
            next_state_reg = 5'b0; // Initialize next_state to zero
            out1_reg = 1'b0; // Initialize out1 to zero
            out2_reg = 1'b0; // Initialize out2 to zero

            for (int i = 0; i < 5; i++) begin
                if (state[i]) begin
                    case (i)
                        0: begin // S0
                            if (!in) begin
                                next_state_reg[0] = 1'b1;
                            end else begin
                                next_state_reg[1] = 1'b1;
                            end
                        end
                        1: begin // S1
                            if (!in) begin
                                next_state_reg[0] = 1'b1;
                            end else begin
                                next_state_reg[2] = 1'b1;
                            end
                        end
                        2: begin // S2
                            if (!in) begin
                                next_state_reg[0] = 1'b1;
                            end else begin
                                next_state_reg[3] = 1'b1;
                            end
                        end
                        3: begin // S3
                            if (!in) begin
                                next_state_reg[0] = 1'b1;
                            end else begin
                                next_state_reg[4] = 1'b1;
                            end
                        end
                        4: begin // S4
                            if (!in) begin
                                next_state_reg[0] = 1'b1;
                            end else begin
                                next_state_reg[5] = 1'b1;
                            end
                        end
                    endcase
                end
            end
        end

        assign next_state = next_state_reg;
        assign out1 = out1_reg;
        assign out2 = out2_reg;
    endmodule

    // Module for states S5 to S9
    module States5_9(
        input in,
        input [4:0] state,
        output [4:0] next_state,
        output out1,
        output out2
    );
        reg [4:0] next_state_reg;
        reg out1_reg;
        reg out2_reg;

        always @(*) begin
            next_state_reg = 5'b0; // Initialize next_state to zero
            out1_reg = 1'b0; // Initialize out1 to zero
            out2_reg = 1'b0; // Initialize out2 to zero

            for (int i = 0; i < 5; i++) begin
                if (state[i]) begin
                    case (i)
                        0: begin // S5
                            if (!in) begin
                                next_state_reg[4] = 1'b1;
                            end else begin
                                next_state_reg[0] = 1'b1;
                            end
                        end
                        1: begin // S6
                            if (!in) begin
                                next_state_reg[3] = 1'b1;
                            end else begin
                                next_state_reg[2] = 1'b1;
                            end
                        end
                        2: begin // S7
                            if (!in) begin
                                next_state_reg[4] = 1'b1;
                            end else begin
                                next_state_reg[2] = 1'b1;
                            end
                            out2_reg = 1'b1;
                        end
                        3: begin // S8
                            if (!in) begin
                                next_state_reg[4] = 1'b1;
                            end else begin
                                next_state_reg[1] = 1'b1;
                            end
                            out1_reg = 1'b1;
                        end
                        4: begin // S9
                            if (!in) begin
                                next_state_reg[4] = 1'b1;
                            end else begin
                                next_state_reg[1] = 1'b1;
                            end
                            out1_reg = 1'b1;
                            out2_reg = 1'b1;
                        end
                    endcase
                end
            end
        end

        assign next_state = next_state_reg;
        assign out1 = out1_reg;
        assign out2 = out2_reg;
    endmodule

    // Instantiate modules for states S0 to S4 and S5 to S9
    States0_4 states0_4(
       .in(in),
       .state(state[4:0]),
       .next_state(next_state_int[4:0]),
       .out1(out1_int),
       .out2(out2_int)
    );

    States5_9 states5_9(
       .in(in),
       .state(state[9:5]),
       .next_state(next_state_int[9:5]),
       .out1(),
       .out2()
    );

    // Assign outputs
    assign next_state = next_state_int;
    assign out1 = out1_int;
    assign out2 = out2_int;

endmodule