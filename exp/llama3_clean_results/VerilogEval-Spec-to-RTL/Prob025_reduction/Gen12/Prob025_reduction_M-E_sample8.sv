module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

reg [0:0] parity_reg;  // Initialize parity register to 0

always @(in) begin
    parity_reg = 1'b0;  // Reset parity register
    for (int i = 0; i < 8; i++) begin
        parity_reg = parity_reg ^ in[i];  // Update parity register
    end
end

assign parity = parity_reg;  // Assign final parity value to output

endmodule