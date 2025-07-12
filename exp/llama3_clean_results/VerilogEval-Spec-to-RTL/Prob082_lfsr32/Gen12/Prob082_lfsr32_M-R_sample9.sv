module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Combinational logic to calculate the new MSB
wire new_msb = q[31] ^ q[21] ^ q[1] ^ q[0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        // Shift the register to the right and assign the new MSB
        q <= {new_msb, q[31:1]};
    end
end

endmodule