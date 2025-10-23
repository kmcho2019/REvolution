module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [6:0] shift_reg; // 7-bit shift register to track last 7 bits
reg disc_reg, flag_reg, err_reg; // Registers for output signals

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 7'b0; // Reset shift register
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        // Shift in new bit, discarding oldest bit
        shift_reg <= {shift_reg[5:0], in};
        
        // Update output signals based on shift register contents
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        
        // Check for discard sequence (0111110)
        if (shift_reg == 7'b0111110) disc_reg <= 1;
        
        // Check for flag sequence (01111110)
        if (shift_reg == 7'b01111110) flag_reg <= 1;
        
        // Check for error sequence (7 consecutive 1s)
        if (shift_reg == 7'b1111111) err_reg <= 1;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule