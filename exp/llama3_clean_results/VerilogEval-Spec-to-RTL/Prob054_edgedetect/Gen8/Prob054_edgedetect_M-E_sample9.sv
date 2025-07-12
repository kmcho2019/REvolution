module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] shift_reg; // Shift register to hold previous input values
reg [7:0] pedge_reg; // Register for output

always @(posedge clk) begin
    // Shift in the new input, shifting out the oldest value
    shift_reg <= {in, shift_reg[7:1]};
    
    // Detect positive edges by comparing the new input with the shifted out previous input
    for (int i = 0; i < 8; i++) begin
        if (shift_reg[i] == 0 && in[i] == 1) begin
            pedge_reg[i] <= 1; // Set the output if a positive edge is detected
        end else begin
            pedge_reg[i] <= 0; // Reset the output otherwise
        end
    end
end

assign pedge = pedge_reg; // Continuous assignment to output

endmodule