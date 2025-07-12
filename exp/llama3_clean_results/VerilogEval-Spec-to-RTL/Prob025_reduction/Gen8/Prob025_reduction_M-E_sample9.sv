module TopModule(
    input [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

reg [7:0] temp_in;
reg [0:0] temp_parity;

always @(*) begin
    temp_parity = 1'b0;  // Initialize parity to 0
    temp_in = in;  // Copy input to temporary variable
    
    // Iterate over each bit of the input
    for (int i = 0; i < 8; i++) begin
        // XOR the current parity with the current input bit
        temp_parity = temp_parity ^ temp_in[i];
    end
    
    // Assign the final parity to the output
    parity = temp_parity;
end

endmodule