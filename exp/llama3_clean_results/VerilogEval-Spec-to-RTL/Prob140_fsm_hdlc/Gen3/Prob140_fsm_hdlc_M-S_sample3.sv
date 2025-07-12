module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] consecutive_ones; // counter for consecutive 1s
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        consecutive_ones <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        if (in) begin
            consecutive_ones <= consecutive_ones + 1;
            if (consecutive_ones == 5) begin
                disc_reg <= 1;
                flag_reg <= 0;
                err_reg <= 0;
            end else if (consecutive_ones == 6) begin
                flag_reg <= 1;
                disc_reg <= 0;
                err_reg <= 0;
            end else if (consecutive_ones > 6) begin
                err_reg <= 1;
                disc_reg <= 0;
                flag_reg <= 0;
            end
        end else begin
            if (consecutive_ones == 5) begin
                disc_reg <= 1;
                flag_reg <= 0;
                err_reg <= 0;
            end else if (consecutive_ones == 6) begin
                flag_reg <= 1;
                disc_reg <= 0;
                err_reg <= 0;
            end
            consecutive_ones <= 0;
            err_reg <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule