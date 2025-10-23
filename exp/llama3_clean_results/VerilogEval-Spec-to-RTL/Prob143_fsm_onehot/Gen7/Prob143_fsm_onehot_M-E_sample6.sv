module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Module for states S0-S3
    module S0_S3(
        input in,
        input [3:0] state,
        output [3:0] next_state,
        output out1,
        output out2
    );
        reg [3:0] next_state_reg;
        reg out1_reg;
        reg out2_reg;

        always @(*) begin
            next_state_reg = 4'b0; // Initialize next_state to zero
            out1_reg = 1'b0; // Initialize out1 to zero
            out2_reg = 1'b0; // Initialize out2 to zero

            for (int i = 0; i < 4; i++) begin
                if (state[i]) begin // Check each state individually
                    case (i)
                        0: next_state_reg[!in? 0 : 1] = 1'b1; // S0
                        1: next_state_reg[!in? 0 : 2] = 1'b1; // S1
                        2: next_state_reg[!in? 0 : 3] = 1'b1; // S2
                        3: next_state_reg[!in? 0 : 0] = 1'b1; // S3
                        default: next_state_reg[0] = 1'b1; // Default state
                    endcase
                end
            end
        end

        assign next_state = next_state_reg;
        assign out1 = out1_reg;
        assign out2 = out2_reg;
    endmodule

    // Module for states S4-S6
    module S4_S6(
        input in,
        input [2:0] state,
        output [2:0] next_state,
        output out1,
        output out2
    );
        reg [2:0] next_state_reg;
        reg out1_reg;
        reg out2_reg;

        always @(*) begin
            next_state_reg = 3'b0; // Initialize next_state to zero
            out1_reg = 1'b0; // Initialize out1 to zero
            out2_reg = 1'b0; // Initialize out2 to zero

            for (int i = 0; i < 3; i++) begin
                if (state[i]) begin // Check each state individually
                    case (i)
                        0: next_state_reg[!in? 0 : 1] = 1'b1; // S4
                        1: next_state_reg[!in? 0 : 2] = 1'b1; // S5
                        2: next_state_reg[!in? 0 : 0] = 1'b1; // S6
                        default: next_state_reg[0] = 1'b1; // Default state
                    endcase
                end
            end
        end

        assign next_state = next_state_reg;
        assign out1 = out1_reg;
        assign out2 = out2_reg;
    endmodule

    // Module for states S7-S9
    module S7_S9(
        input in,
        input [2:0] state,
        output [2:0] next_state,
        output out1,
        output out2
    );
        reg [2:0] next_state_reg;
        reg out1_reg;
        reg out2_reg;

        always @(*) begin
            next_state_reg = 3'b0; // Initialize next_state to zero
            out1_reg = 1'b0; // Initialize out1 to zero
            out2_reg = 1'b0; // Initialize out2 to zero

            for (int i = 0; i < 3; i++) begin
                if (state[i]) begin // Check each state individually
                    case (i)
                        0: next_state_reg[!in? 0 : 1] = 1'b1; // S7
                        1: next_state_reg[!in? 0 : 2] = 1'b1; // S8
                        2: next_state_reg[!in? 0 : 0] = 1'b1; // S9
                        default: next_state_reg[0] = 1'b1; // Default state
                    endcase
                end
            end
        end

        assign next_state = next_state_reg;
        assign out1 = out1_reg;
        assign out2 = out2_reg;
    endmodule

    // Instantiate modules
    S0_S3 s0_s3_module(
        .in(in),
        .state(state[3:0]),
        .next_state(next_state[3:0]),
        .out1(),
        .out2()
    );

    S4_S6 s4_s6_module(
        .in(in),
        .state(state[6:4]),
        .next_state(next_state[6:4]),
        .out1(),
        .out2()
    );

    S7_S9 s7_s9_module(
        .in(in),
        .state(state[9:7]),
        .next_state(next_state[9:7]),
        .out1(),
        .out2()
    );

    // Combine outputs
    assign out1 = (state[8] && in) || (state[9] && in);
    assign out2 = (state[7] && in) || (state[9] && in);

endmodule