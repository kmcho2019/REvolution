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

    // Shift register update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            {disc_reg, flag_reg, err_reg} <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
            
            // Clear outputs after one cycle
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
            
            // Pattern detection (combinatorial matching)
            if (shift_reg[5:0] == 6'b111110 && in == 0) begin
                disc_reg <= 1;
            end
            if (shift_reg == 7'b1111110) begin
                flag_reg <= 1;
            end
            if (shift_reg[6:0] == 7'b1111111) begin
                err_reg <= 1;
            end
        end
    end

    // Output assignments
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule