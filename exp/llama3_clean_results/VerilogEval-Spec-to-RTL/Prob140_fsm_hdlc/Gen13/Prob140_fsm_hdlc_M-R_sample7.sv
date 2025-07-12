module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // counter for consecutive 1s
reg state; // 0: IDLE, 1: COUNTING, 2: ERROR
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            0: begin // IDLE
                if (in) begin
                    state <= 1; // transition to COUNTING
                    count <= 1;
                end
            end
            1: begin // COUNTING
                if (in) begin
                    count <= count + 1;
                    if (count == 6) begin
                        state <= 0; // transition back to IDLE
                        flag_reg <= 1;
                    end else if (count > 6) begin
                        state <= 2; // transition to ERROR
                        err_reg <= 1;
                    end
                end else begin
                    if (count == 5) begin
                        disc_reg <= 1;
                    end
                    state <= 0; // transition back to IDLE
                    count <= 0;
                end
            end
            2: begin // ERROR
                if (~in) begin
                    state <= 0; // transition back to IDLE
                    count <= 0;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule