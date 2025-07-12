module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter for consecutive 1s
reg disc_reg, flag_reg, err_reg; // Output registers

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
                disc_reg <= 1;
            end else if (count == 6) begin
                flag_reg <= 1;
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