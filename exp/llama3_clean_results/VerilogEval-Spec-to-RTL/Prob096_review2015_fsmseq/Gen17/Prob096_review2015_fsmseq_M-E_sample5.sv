module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register

// Target sequence
localparam SEQUENCE = 4'b1101;

// Update shift register and check for sequence
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        start_shifting <= 0; // Reset start_shifting
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // Shift in new data bit
        if (shift_reg == SEQUENCE) begin
            start_shifting <= 1; // Set start_shifting if sequence detected
        end
    end
end

endmodule