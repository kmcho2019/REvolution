module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state; // 0: initial, 1: seen 1, 2: seen 5 ones, 3: seen flag, 4: error
    reg disc_reg, flag_reg, err_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            case (state)
                0: begin // initial state
                    if (in) begin
                        state <= 1;
                    end else begin
                        state <= 0;
                    end
                end
                1: begin // seen 1
                    if (in) begin
                        state <= 2;
                    end else begin
                        state <= 0;
                    end
                end
                2: begin // seen 5 ones
                    if (in) begin
                        state <= 3; // potential flag
                        disc_reg <= 1; // set disc flag
                    end else begin
                        state <= 0; // reset state
                    end
                end
                3: begin // seen flag pattern
                    if (in) begin
                        state <= 4; // error
                        err_reg <= 1; // set error flag
                    end else begin
                        state <= 0; // reset state
                        flag_reg <= 1; // set flag
                    end
                end
                4: begin // error
                    if (~in) begin
                        state <= 0; // reset state
                    end else begin
                        state <= 4; // stay in error state
                    end
                end
            endcase
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

    always @(posedge clk) begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end

endmodule