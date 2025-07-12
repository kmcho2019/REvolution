module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the new MSB by XORing the tapped bits
        reg new_msb = q[31] ^ q[21] ^ q[1] ^ q[0];
        // Shift the register to the right and assign the new MSB
        q <= {new_msb, q[31:1]};
    end
end

endmodule