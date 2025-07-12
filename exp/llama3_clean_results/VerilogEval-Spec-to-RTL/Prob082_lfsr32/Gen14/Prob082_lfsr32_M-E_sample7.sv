module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

parameter TAP_1 = 32'h80000000; // tap at position 32
parameter TAP_2 = 32'h00400000; // tap at position 22
parameter TAP_3 = 32'h00000002; // tap at position 2
parameter TAP_4 = 32'h00000001; // tap at position 1 (LSB)

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the feedback term by XORing the taps
        reg [0:0] fb;
        fb = (q[31] ^ q[21] ^ q[1] ^ q[0]);
        
        // Shift the current state to the right and update the MSB with the feedback term
        q <= {fb, q[31:1]};
    end
end

endmodule