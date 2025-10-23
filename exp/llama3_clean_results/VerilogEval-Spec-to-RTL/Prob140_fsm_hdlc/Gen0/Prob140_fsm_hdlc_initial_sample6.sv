module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3-bit state register
reg disc_reg, flag_reg, err_reg; // Output registers

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to IDLE state
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in) begin
                    state <= 1; // Transition to ONE state
                end else begin
                    state <= 0; // Stay in IDLE state
                end
            end
            1: begin // ONE state
                if (in) begin
                    state <= 2; // Transition to TWO state
                end else begin
                    state <= 0; // Transition back to IDLE state
                end
            end
            2: begin // TWO state
                if (in) begin
                    state <= 3; // Transition to THREE state
                end else begin
                    state <= 0; // Transition back to IDLE state
                end
            end
            3: begin // THREE state
                if (in) begin
                    state <= 4; // Transition to FOUR state
                end else begin
                    state <= 0; // Transition back to IDLE state
                end
            end
            4: begin // FOUR state
                if (in) begin
                    state <= 5; // Transition to FIVE state
                end else begin
                    state <= 0; // Transition back to IDLE state
                end
            end
            5: begin // FIVE state
                if (in) begin
                    state <= 6; // Transition to SIX state
                    disc_reg <= 1; // Assert disc signal
                end else begin
                    state <= 0; // Transition back to IDLE state
                end
            end
            6: begin // SIX state
                if (in) begin
                    state <= 7; // Transition to FLAG state
                end else begin
                    state <= 0; // Transition back to IDLE state
                    flag_reg <= 1; // Assert flag signal
                end
            end
            7: begin // FLAG state
                if (in) begin
                    state <= 7; // Stay in FLAG state
                    err_reg <= 1; // Assert err signal
                end else begin
                    state <= 0; // Transition back to IDLE state
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @(posedge clk) begin
    if (~reset) begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
end

endmodule