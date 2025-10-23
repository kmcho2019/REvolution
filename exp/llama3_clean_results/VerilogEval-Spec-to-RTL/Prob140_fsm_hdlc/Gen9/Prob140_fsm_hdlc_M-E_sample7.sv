module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] counter; // Counter for consecutive ones
reg [2:0] flag_counter; // Counter for consecutive ones after flag
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        flag_counter <= 0;
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
                if (~in) begin
                    disc_reg <= 1;
                    counter <= 0;
                end
            end else if (counter == 6) begin
                if (~in) begin
                    flag_reg <= 1;
                    counter <= 0;
                end else begin
                    err_reg <= 1;
                end
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