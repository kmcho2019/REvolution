module TopModule(
    input  clk,       // Clock signal
    input  [7:0] in,  // 8-bit input
    output parity      // Parity output
);

reg [7:0] shift_reg;  // Shift register to hold input bits
reg parity_reg;       // Register to hold the final parity result

integer i;            // Loop counter

always @(posedge clk) begin
    shift_reg <= in;  // Load input into shift register on clock edge
    parity_reg <= 1'b0;  // Reset parity register
    
    // Compute parity by shifting and XORing bits
    for (i = 0; i < 8; i++) begin
        parity_reg <= parity_reg ^ shift_reg[i];
    end
end

assign parity = parity_reg;  // Assign computed parity to output

endmodule