module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// State definitions
enum logic [2:0] { S0, S1, S2, S3, S4, S5, S6, ERR } state, nextState;

// Outputs are registered for a complete cycle
logic disc_reg, flag_reg, err_reg;

// Assign outputs based on the current state
always_comb begin
    disc_reg = 0;
    flag_reg = 0;
    err_reg = 0;
    case (state)
        S6: disc_reg = 1;
        S5: flag_reg = 1;
        ERR: err_reg = 1;
        default: ;
    endcase
end

// State transition logic
always_comb begin
    case (state)
        S0: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = S1;
            endcase
        S1: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = S2;
            endcase
        S2: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = S3;
            endcase
        S3: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = S4;
            endcase
        S4: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = S5;
            endcase
        S5: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = S6;
            endcase
        S6: case (in)
                1'b0: nextState = S0;
                1'b1: nextState = ERR;
            endcase
        ERR: nextState = (in == 1'b1) ? ERR : S0;
        default: nextState = S0;
    endcase
end

// Synchronous reset
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule