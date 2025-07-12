module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1;
    end else begin
        q[4] <= q[3] ^ q[0];
        q[3] <= q[2] ^ q[0];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= 0; // this will be overwritten by the XOR result of q[4] and q[0] for the MSB, 
                   // but we need a placeholder to complete the shift operation
        // Since we are shifting right, the LSB is lost, we can assign it to 0.
        // But to correctly implement the Galois LFSR, we actually need to use the result of q[4] and q[0] 
        // to update q[4] and then let the rest of the bits shift, so we adjust the order of operations
        // and directly assign the correct value to each bit
        q[4] <= q[3] ^ q[0];
        q[3] <= q[2] ^ q[0];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= 0; 
    end
end

endmodule