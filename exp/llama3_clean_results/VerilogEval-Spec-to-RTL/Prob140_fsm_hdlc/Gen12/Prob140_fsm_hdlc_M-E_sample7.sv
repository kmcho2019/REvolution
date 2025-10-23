module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] ones_counter; // Counter for consecutive ones
reg [2:0] total_counter; // Counter for total bits since last flag
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        ones_counter <= 0;
        total_counter <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            ones_counter <= ones_counter + 1;
            total_counter <= total_counter + 1;

            if (ones_counter == 5) begin
                if (~in) begin
                    disc_reg <= 1;
                    ones_counter <= 0;
                end
            end else if (ones_counter == 6) begin
                if (~in) begin
                    flag_reg <= 1;
                    ones_counter <= 0;
                    total_counter <= 0;
                end else begin
                    err_reg <= 1;
                end
            end else if (ones_counter > 6) begin
                err_reg <= 1;
            end
        end else begin
            ones_counter <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule