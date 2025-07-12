module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] consecutive_ones;
reg [2:0] total_ones;
reg disc_reg, flag_reg, err_reg;
reg state_idle, state_counting_ones, state_flag_detected;

always @(posedge clk) begin
    if (reset) begin
        consecutive_ones <= 0;
        total_ones <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        state_idle <= 1;
        state_counting_ones <= 0;
        state_flag_detected <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (state_idle) begin
            if (in) begin
                consecutive_ones <= 1;
                state_idle <= 0;
                state_counting_ones <= 1;
            end else begin
                consecutive_ones <= 0;
                state_idle <= 1;
                state_counting_ones <= 0;
            end
        end else if (state_counting_ones) begin
            if (in) begin
                consecutive_ones <= consecutive_ones + 1;
                if (consecutive_ones == 5) begin
                    // discard bit
                    disc_reg <= 1;
                    consecutive_ones <= 0;
                    state_idle <= 1;
                    state_counting_ones <= 0;
                end else if (consecutive_ones == 6) begin
                    // flag detected
                    flag_reg <= 1;
                    consecutive_ones <= 0;
                    state_idle <= 1;
                    state_counting_ones <= 0;
                end else if (consecutive_ones > 6) begin
                    // error detected
                    err_reg <= 1;
                    consecutive_ones <= 0;
                    state_idle <= 1;
                    state_counting_ones <= 0;
                end
            end else begin
                consecutive_ones <= 0;
                state_idle <= 1;
                state_counting_ones <= 0;
            end
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule