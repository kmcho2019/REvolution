module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // 1-bit parity output
);

reg parity_reg; // Register to store the parity bit

always @(*) begin
    parity_reg = 1'b0; // Initialize parity_reg to 0
    for (int i = 0; i < 8; i++) begin
        parity_reg = parity_reg ^ in[i]; // XOR each input bit with parity_reg
    end
end

assign parity = parity_reg; // Assign the computed parity to the output

endmodule