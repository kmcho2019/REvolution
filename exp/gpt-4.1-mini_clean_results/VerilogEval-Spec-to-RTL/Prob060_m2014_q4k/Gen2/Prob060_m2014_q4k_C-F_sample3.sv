module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    // 4-bit shift register to hold the shifted data
    reg [3:0] shift_reg;

    // Synchronous active-low reset, positive edge triggered
    always @(posedge clk) begin
        if (!resetn)
            shift_reg <= 4'b0000;          // Reset shift register to 0
        else
            shift_reg <= {shift_reg[2:0], in}; // Shift in new bit
    end

    // Output is the most significant bit of the shift register
    assign out = shift_reg[3];

endmodule