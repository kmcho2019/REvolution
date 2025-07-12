module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR to 32'h1
        q <= 32'h1;
    end else begin
        // Calculate the new MSB by XORing the tapped bits with the LSB
        reg new_msb;
        new_msb = q[0] ^ q[21] ^ q[30] ^ q[31];
        
        // Shift the current state right and add the new MSB
        q <= {new_msb, q[31:1]};
    end
end

endmodule