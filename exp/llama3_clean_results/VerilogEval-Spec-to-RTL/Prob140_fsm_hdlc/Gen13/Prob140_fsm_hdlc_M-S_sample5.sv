module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] counter; // Counter to track consecutive ones
reg state;         // State variable: 0 - normal, 1 - waiting for zero after 5 ones or flag/error
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (state == 0) begin
            if (in) begin
                counter <= counter + 1;
                if (counter == 5) state <= 1;
            end else begin
                counter <= 0;
            end
        end else begin // state == 1
            if (in) begin
                counter <= counter + 1;
                if (counter >= 7) begin
                    err_reg <= 1;
                end
            end else begin
                if (counter == 6) begin
                    flag_reg <= 1;
                end else if (counter == 5) begin
                    disc_reg <= 1;
                end
                state <= 0;
                counter <= 0;
            end
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule