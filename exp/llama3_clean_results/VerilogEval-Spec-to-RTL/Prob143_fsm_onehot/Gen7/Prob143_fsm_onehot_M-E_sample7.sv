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

    // Define the states that use one-hot encoding
    reg [9:0] one_hot_states;
    assign one_hot_states = state[5:0];

    // Define the states that use binary encoding
    reg [3:0] binary_states;
    assign binary_states = {state[9], state[8], state[7], state[6]};

    // One-hot encoding submodule
    one_hot_submodule one_hot_sub(
       .in(in),
       .state(one_hot_states),
       .next_state(one_hot_next_state),
       .out1(out1_one_hot),
       .out2(out2_one_hot)
    );

    // Binary encoding submodule
    binary_submodule binary_sub(
       .in(in),
       .state(binary_states),
       .next_state(binary_next_state),
       .out1(out1_binary),
       .out2(out2_binary)
    );

    // Output logic submodule
    output_submodule output_sub(
       .state(state),
       .out1(out1_reg),
       .out2(out2_reg)
    );

    // Clock gating
    reg clock_enable;
    assign clock_enable = (one_hot_states!= 0) || (binary_states!= 0);

    always @(*) begin
        next_state_reg = 0;
        if (clock_enable) begin
            // Combine the next states from the one-hot and binary encoding submodules
            next_state_reg[5:0] = one_hot_next_state;
            next_state_reg[9:6] = binary_next_state;
        end
    end

    assign next_state = next_state_reg;

endmodule

module one_hot_submodule(
    input in,
    input [5:0] state,
    output [5:0] next_state,
    output out1,
    output out2
);

    reg [5:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 0;
        out1_reg = 0;
        out2_reg = 0;
        case (1'b1)
            state[0]: begin // S0
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
            end
            state[1]: begin // S1
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[2] = 1'b1;
                end
            end
            state[2]: begin // S2
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[3] = 1'b1;
                end
            end
            state[3]: begin // S3
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[4] = 1'b1;
                end
            end
            state[4]: begin // S4
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[5] = 1'b1;
                end
            end
            state[5]: begin // S5
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[5] = 1'b1;
                end
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule

module binary_submodule(
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
        next_state_reg = 0;
        out1_reg = 0;
        out2_reg = 0;
        case (1'b1)
            state[0]: begin // S6
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
            end
            state[1]: begin // S7
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out2_reg = 1'b1;
            end
            state[2]: begin // S8
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[2] = 1'b1;
                end
                out1_reg = 1'b1;
            end
            state[3]: begin // S9
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[2] = 1'b1;
                end
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule

module output_submodule(
    input [9:0] state,
    output out1,
    output out2
);

    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        out1_reg = 0;
        out2_reg = 0;
        case (1'b1)
            state[7]: begin // S7
                out2_reg = 1'b1;
            end
            state[8]: begin // S8
                out1_reg = 1'b1;
            end
            state[9]: begin // S9
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
        endcase
    end

    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule