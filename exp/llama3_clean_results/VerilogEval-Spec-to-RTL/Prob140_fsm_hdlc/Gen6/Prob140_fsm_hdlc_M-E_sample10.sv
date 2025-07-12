module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // 3 bits to represent 0-7
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
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
                if (in) begin
                    disc_reg <= 1;
                end
            end else if (count == 6) begin
                if (!in) begin
                    flag_reg <= 1;
                end else begin
                    err_reg <= 1;
                end
            end else if (count > 6) begin
                err_reg <= 1;
            end
        end else begin
            count <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule