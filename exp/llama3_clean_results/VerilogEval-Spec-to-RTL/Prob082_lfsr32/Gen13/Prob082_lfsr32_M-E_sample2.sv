module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] taps_mask;

initial begin
    taps_mask = 32'h00000008; // 1 at positions 32, 22, 2, and 1 (considering 0-indexing)
    taps_mask |= 32'h00400000; // tap at position 22
    taps_mask |= 32'h00000002; // tap at position 1
    taps_mask |= 32'h00000001; // tap at position 0 (LSB)
end

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the feedback term using the tap mask
        reg [31:0] feedback;
        feedback = (q & taps_mask);
        
        // Calculate the XOR of the taps to get the feedback bit
        reg [0:0] fb;
        fb = feedback[30] ^ feedback[21] ^ feedback[1] ^ feedback[0];
        
        // Shift the current state to the right and update the MSB with the feedback term
        q <= {q[30:0], fb};
    end
end

endmodule