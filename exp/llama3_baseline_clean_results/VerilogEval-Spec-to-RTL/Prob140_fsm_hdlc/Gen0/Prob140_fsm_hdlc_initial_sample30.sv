module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3-bit counter to track consecutive 1s
reg disc_reg, flag_reg, err_reg; // registers for output signals

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // no consecutive 1s
                if (in) state <= 1;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1, 2, 3, 4: begin // 1-4 consecutive 1s
                if (in) state <= state + 1;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin // 5 consecutive 1s
                if (in) state <= 6; // discard next 0
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            6: begin // discard state
                state <= 0; // reset state
                disc_reg <= 1; // discard bit
                flag_reg <= 0;
                err_reg <= 0;
            end
            7: begin // error state
                if (~in) state <= 0; // reset state on 0
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1; // error
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 6 && ~in) flag_reg <= 1; // flag on 0 after 6 consecutive 1s
    else flag_reg <= 0;
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule