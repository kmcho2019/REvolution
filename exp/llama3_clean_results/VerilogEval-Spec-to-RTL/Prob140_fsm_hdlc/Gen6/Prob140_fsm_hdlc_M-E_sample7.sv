module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] consecutive_ones;
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        consecutive_ones <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        // Consecutive Ones Detector
        if (in) begin
            consecutive_ones <= consecutive_ones + 1;
        end else begin
            consecutive_ones <= 0;
        end

        // Flag and Error Detector
        if (consecutive_ones == 6) begin
            if (~in) begin
                flag_reg <= 1;
            end else begin
                err_reg <= 1;
            end
        end else if (consecutive_ones == 5) begin
            disc_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule