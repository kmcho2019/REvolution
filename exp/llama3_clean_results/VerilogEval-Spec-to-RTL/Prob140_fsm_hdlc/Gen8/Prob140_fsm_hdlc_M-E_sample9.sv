module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count_ones; // Counter for consecutive ones
reg [1:0] count_zeros; // Counter for consecutive zeros
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        count_ones <= 0;
        count_zeros <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            count_ones <= count_ones + 1;
            count_zeros <= 0;
            if (count_ones == 6) begin
                if (count_zeros == 0) flag_reg <= 1;
                else disc_reg <= 1;
            end else if (count_ones >= 7) begin
                err_reg <= 1;
            end
        end else begin
            count_zeros <= count_zeros + 1;
            count_ones <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule