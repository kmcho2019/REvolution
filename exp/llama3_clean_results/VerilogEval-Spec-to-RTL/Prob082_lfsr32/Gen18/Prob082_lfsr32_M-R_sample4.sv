module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Calculate the new MSB based on the tap positions
wire msb_next = q[31] ^ q[21] ^ q[1] ^ q[0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to 32'h1
        q <= 32'h1;
    end else begin
        // Shift right and calculate new MSB
        q <= {msb_next, q[31:1]};
    end
end

endmodule