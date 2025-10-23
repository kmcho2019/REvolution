module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [6:0] shift_reg;
    reg disc_reg, flag_reg, err_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Set outputs for next cycle
            disc_reg <= (shift_reg == 7'b0111110);
            flag_reg <= (shift_reg == 7'b0111111);
            err_reg <= (shift_reg[6:0] == 7'b1111111);
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule