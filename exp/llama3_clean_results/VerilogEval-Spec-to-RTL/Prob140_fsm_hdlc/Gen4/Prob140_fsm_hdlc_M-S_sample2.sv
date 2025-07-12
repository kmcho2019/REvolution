module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // state variable
reg [2:0] consecutive_ones; // counter for consecutive 1s
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle state
        consecutive_ones <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (in) begin
                    consecutive_ones <= consecutive_ones + 1;
                    if (consecutive_ones == 5) begin
                        state <= 1; // flag detection state
                    end else if (consecutive_ones > 5) begin
                        state <= 2; // error detection state
                    end
                end else begin
                    consecutive_ones <= 0;
                end
            end
            1: begin // flag detection state
                if (in) begin
                    consecutive_ones <= consecutive_ones + 1;
                    if (consecutive_ones == 6) begin
                        flag_reg <= 1;
                    end
                end else begin
                    if (consecutive_ones == 6) begin
                        flag_reg <= 1;
                    end else if (consecutive_ones == 5) begin
                        disc_reg <= 1;
                    end
                    state <= 0; // return to idle state
                    consecutive_ones <= 0;
                end
            end
            2: begin // error detection state
                if (in) begin
                    consecutive_ones <= consecutive_ones + 1;
                    err_reg <= 1;
                end else begin
                    state <= 0; // return to idle state
                    consecutive_ones <= 0;
                    err_reg <= 0;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule