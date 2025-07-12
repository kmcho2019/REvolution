module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] shift_reg; // 8-bit shift register to store previous values

always @(posedge clk) begin
    // Shift in the new input values
    shift_reg <= {shift_reg[6:0], in[7]};
    
    // Compare each bit of the input with the corresponding bit in the shift register
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && shift_reg[i] == 0) begin
            pedge[i] <= 1; // Set the output bit if a positive edge is detected
        end else begin
            pedge[i] <= 0; // Reset the output bit otherwise
        end
    end
end

endmodule