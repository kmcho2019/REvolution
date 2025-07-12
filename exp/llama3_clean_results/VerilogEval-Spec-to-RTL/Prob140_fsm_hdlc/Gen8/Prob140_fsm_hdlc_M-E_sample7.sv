module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [4:0] shift_reg; // 5-bit shift register to hold the last 5 bits
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 5'b0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        // Shift the register to the left and add the new bit
        shift_reg <= {shift_reg[3:0], in};
        
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        
        // Check for 5 consecutive ones followed by a zero (discard bit)
        if (shift_reg == 5'b11110) begin
            disc_reg <= 1;
        end
        
        // Check for 6 consecutive ones followed by a zero (flag)
        if (shift_reg == 5'b111110) begin
            flag_reg <= 1;
        end
        
        // Check for 7 or more consecutive ones (error)
        if (shift_reg == 5'b11111 && in == 1'b1) begin
            err_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule