module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] consecutive_ones; // Counter for consecutive ones
reg [3:0] total_bits; // Counter for total bits since last flag/reset
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        consecutive_ones <= 0;
        total_bits <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            consecutive_ones <= consecutive_ones + 1;
            total_bits <= total_bits + 1;
        end else begin
            consecutive_ones <= 0;
            if (consecutive_ones == 5) disc_reg <= 1; // Discard condition
            total_bits <= 0;
        end

        if (consecutive_ones == 6 && total_bits == 8) flag_reg <= 1; // Flag condition
        if (consecutive_ones >= 7) err_reg <= 1; // Error condition
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule