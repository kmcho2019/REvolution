module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    shift_reg[7] <= d;
    for (int i = 6; i >= 0; i--) begin
        shift_reg[i] <= shift_reg[i+1];
    end
    q <= shift_reg;
end

endmodule