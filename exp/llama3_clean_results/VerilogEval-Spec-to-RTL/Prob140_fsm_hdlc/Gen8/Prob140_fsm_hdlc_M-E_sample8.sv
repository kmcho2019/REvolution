module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] count; // Counter for consecutive ones
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
            if (count == 6) begin // Exactly 6 ones, flag condition
                flag_reg <= 1;
            end else if (count >= 7) begin // 7 or more ones, error condition
                err_reg <= 1;
            end
        end else begin
            if (count == 5) begin // 5 consecutive ones followed by a zero, discard
                disc_reg <= 1;
            end
            count <= 0; // Reset counter on zero
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule