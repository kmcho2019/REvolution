// Novel sequential parity generator module
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Initialize a register to hold the accumulated parity result
reg [7:0] shift_reg;
reg parity_reg;

// Sequentially XOR each input bit with the accumulated result
always @(posedge in[0]) begin
    shift_reg <= in;
    parity_reg <= 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity_reg <= parity_reg ^ shift_reg[i];
    end
end

// Output the final parity result
assign parity = parity_reg;

endmodule