module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 0: reset state, 1: one 1 seen, 2: two 1s seen, 3: three 1s seen, 4: four 1s seen, 5: five 1s seen
reg disc_reg, flag_reg, err_reg; // registers to hold output values for one cycle

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // reset state
                if (in) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // one 1 seen
                if (in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // two 1s seen
                if (in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
            end
            3: begin // three 1s seen
                if (in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin // four 1s seen
                if (in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
            end
            5: begin // five 1s seen
                if (in) begin
                    state <= 5; // stay in this state to detect error
                    err_reg <= 1; // set error
                end else begin
                    state <= 0; // reset state
                    disc_reg <= 1; // set discard
                end
            end
            default: state <= 0; // default case
        endcase

        // check for flag
        if (state == 5 && !in) begin
            flag_reg <= 1; // set flag
        end

        // reset output registers
        if (!reset) begin
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end

        // reset output registers for next cycle
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
end

endmodule