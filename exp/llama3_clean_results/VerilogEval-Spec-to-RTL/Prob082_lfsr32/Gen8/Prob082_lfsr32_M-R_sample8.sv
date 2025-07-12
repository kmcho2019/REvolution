module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q; // Temporary variable to hold the next state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the XOR of the bits at the tap positions
        next_q[31] = q[31] ^ q[22] ^ q[2] ^ q[1];
        
        // Shift the LFSR to the right, with the most significant bit being the result of the XOR operation
        next_q[30:0] = q[31:1];
        
        q <= next_q;
    end
end

endmodule