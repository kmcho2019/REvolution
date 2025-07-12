// Novel module to reverse the bit ordering of an 8-bit input using iterative shifting
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Initialize the output vector
    reg [7:0] out_reg;

    // Always block for combinational logic
    always @(*) begin
        // Initialize out_reg with the input vector
        out_reg = in;
        
        // Perform iterative shifting to reverse the bit order
        for (int i = 0; i < 4; i++) begin
            // Swap bits in pairs (e.g., bit 0 with bit 7, bit 1 with bit 6, etc.)
            out_reg = {out_reg[7-2*i], out_reg[6-2*i], out_reg[1+2*i], out_reg[0+2*i], 
                       out_reg[5-2*i], out_reg[4-2*i], out_reg[3+2*i], out_reg[2+2*i]};
        end
    end

    // Assign the result to the output vector
    assign out = out_reg;

endmodule