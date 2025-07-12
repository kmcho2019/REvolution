module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // State register
reg [2:0] next_state; // Next state register

// Output signals
reg disc_reg, flag_reg, err_reg;

// State machine states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

always @(*) begin
    // Initialize output signals
    disc_reg = 1'b0;
    flag_reg = 1'b0;
    err_reg = 1'b0;

    case (state)
        S0: begin
            if (in) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (in) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if (in) next_state = S3;
            else next_state = S0;
        end
        S3: begin
            if (in) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (in) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (in) next_state = S6;
            else begin
                next_state = S0;
                disc_reg = 1'b1; // Discard bit
            end
        end
        S6: begin
            if (in) next_state = S7;
            else begin
                next_state = S0;
                flag_reg = 1'b1; // Flag
            end
        end
        S7: begin
            if (in) next_state = S7;
            else next_state = S0;
            err_reg = 1'b1; // Error
        end
        default: next_state = S0;
    endcase
end

always @(posedge clk) begin
    if (reset) state <= S0;
    else state <= next_state;

    disc <= disc_reg;
    flag <= flag_reg;
    err <= err_reg;
end

endmodule