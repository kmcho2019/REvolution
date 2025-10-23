module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge = 0
);

reg [7:0] shift_reg; // Shift register to store current and previous values

always @(posedge clk) begin
    // Update shift register
    shift_reg <= {in, shift_reg[7:1]};
    
    // Detect positive edge transitions
    for (int i = 0; i < 8; i++) begin
        if (shift_reg[i] == 0 && in[i] == 1) begin
            pedge[i] <= 1; // Set the corresponding output bit if a positive edge transition is detected
        end else begin
            pedge[i] <= 0; // Reset the output bit otherwise
        end
    end
end

endmodule