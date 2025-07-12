module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// State definitions
parameter S0 = 0;
parameter S1 = 1;
parameter S2 = 2;
parameter S3 = 3;
parameter S4 = 4;
parameter S5 = 5;
parameter S6 = 6;
parameter S7 = 7;
parameter SF = 8;

// Current state and next state
reg [2:0] state, next_state;

// Output signals
reg disc_reg, flag_reg, err_reg;

// Combinational logic for next state and outputs
always @(*) begin
    case (state)
        S0: begin
            if (in) next_state = S1;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S1: begin
            if (in) next_state = S2;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S2: begin
            if (in) next_state = S3;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S3: begin
            if (in) next_state = S4;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S4: begin
            if (in) next_state = S5;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S5: begin
            if (in) next_state = S6;
            else next_state = S0;
            disc_reg = 1;
            flag_reg = 0;
            err_reg = 0;
        end
        S6: begin
            if (in) next_state = S7;
            else next_state = SF;
            disc_reg = 0;
            flag_reg = 1;
            err_reg = 0;
        end
        S7: begin
            if (in) next_state = S7;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 1;
        end
        SF: begin
            if (in) next_state = S1;
            else next_state = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= next_state;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule