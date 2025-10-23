module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {d, shift_reg[7:1]};
    q <= shift_reg;
end

initial begin
    shift_reg = 8'd0;  // Initialize shift register to 0
    q = 8'd0;  // Initialize output q to 0
end

endmodule