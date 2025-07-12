module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] consec_ones; // Counter for consecutive ones
reg [2:0] total_bits;   // Counter for total bits since last flag or discard
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        consec_ones <= 0;
        total_bits <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            consec_ones <= consec_ones + 1;
            total_bits <= total_bits + 1;

            if (consec_ones == 5) begin
                disc_reg <= 1;
            end elseif (consec_ones > 7) begin
                err_reg <= 1;
            end
        end else begin
            if (consec_ones == 6) begin
                flag_reg <= 1;
            end
            consec_ones <= 0;
            total_bits <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule