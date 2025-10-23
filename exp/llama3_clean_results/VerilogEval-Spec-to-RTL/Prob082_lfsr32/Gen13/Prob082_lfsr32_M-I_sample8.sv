module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the feedback term (XOR of the taps)
        logic fb = q[31] ^ q[22] ^ q[2] ^ q[1];
        
        // Shift the current state to the right and update the LSB with the feedback term
        q <= {q[30:0], fb};
    end
end

endmodule