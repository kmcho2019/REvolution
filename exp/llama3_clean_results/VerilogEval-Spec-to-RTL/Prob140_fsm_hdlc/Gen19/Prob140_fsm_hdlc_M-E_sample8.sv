module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] counter; // Counter to track consecutive ones
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            counter <= counter + 1;

            if (counter == 5) begin
                disc_reg <= 1;
            end else if (counter == 6 && !in) begin
                flag_reg <= 1;
            end else if (counter > 6) begin
                err_reg <= 1;
            end
        end else begin
            counter <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule