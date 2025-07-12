module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] c1; // Counter for consecutive ones
reg [2:0] c2; // Counter for the overall sequence
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        c1 <= 0;
        c2 <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            c1 <= c1 + 1;
            if (c1 == 5) begin
                if (c2 == 0) begin // First '1' in the sequence
                    c2 <= 1;
                end
            end else if (c1 == 6) begin
                flag_reg <= 1;
                c1 <= 0;
                c2 <= 0;
            end else if (c1 > 6) begin
                err_reg <= 1;
                c1 <= 0;
                c2 <= 0;
            end
        end else begin
            if (c1 == 5) begin
                disc_reg <= 1;
            end
            c1 <= 0;
            c2 <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule