module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Combinational logic to calculate the new MSB
wire new_msb = q[0] ^ q[1] ^ q[2] ^ q[22];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        // Shift the register to the right, with tap positions XORed with the LSB
        q[31] <= new_msb;
        for (int i = 30; i > 0; i--) begin
            if ((i == 21) || (i == 1) || (i == 0)) begin
                q[i] <= q[i+1] ^ q[0];
            end else begin
                q[i] <= q[i+1];
            end
        end
        q[0] <= q[31];
    end
end

endmodule