module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

// Synchronous reset to 32'h1
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the new LSB value based on the taps
        reg lsb_new = q[0] ^ q[31] ^ q[21] ^ q[1];
        
        // Shift all bits to the right and insert the new LSB
        q <= {q[30:0], lsb_new};
    end
end

endmodule