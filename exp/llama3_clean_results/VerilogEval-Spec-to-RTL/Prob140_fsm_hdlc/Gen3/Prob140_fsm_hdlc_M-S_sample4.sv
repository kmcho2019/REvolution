module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter to track consecutive ones
reg prev_in; // Previous input
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

        prev_in <= in;

        if (in) begin
            count <= count + 1;
            if (count == 7) err_reg <= 1;
        end else if (prev_in) begin
            if (count == 5) disc_reg <= 1;
            if (count == 6) flag_reg <= 1;
            count <= 0;
        end else begin
            count <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule