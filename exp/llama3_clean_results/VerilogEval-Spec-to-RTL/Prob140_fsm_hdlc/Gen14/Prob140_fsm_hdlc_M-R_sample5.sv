module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // 3-bit counter to count consecutive 1s and 0s
reg prev_in; // register to store previous input bit
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        prev_in <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            count <= count + 1;
            if (count == 5) begin
                if (~prev_in) begin
                    disc_reg <= 1;
                end
            end else if (count == 6) begin
                flag_reg <= 1;
            end else if (count >= 7) begin
                err_reg <= 1;
            end
        end else begin
            count <= 0;
        end

        prev_in <= in;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule