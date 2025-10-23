module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] ones_count; // counter for consecutive ones
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        ones_count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        if (in) begin
            ones_count <= ones_count + 1;
        end else begin
            ones_count <= 0;
        end

        if (ones_count == 5 && !in) begin
            disc_reg <= 1; // discard bit
        end else begin
            disc_reg <= 0;
        end

        if (ones_count == 6 && !in) begin
            flag_reg <= 1; // flag
        end else begin
            flag_reg <= 0;
        end

        if (ones_count >= 7) begin
            err_reg <= 1; // error
        end else begin
            err_reg <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule