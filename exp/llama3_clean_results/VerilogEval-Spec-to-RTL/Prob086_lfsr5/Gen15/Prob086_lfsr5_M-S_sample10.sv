module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Reset the LFSR output to 1
    end else begin
        q[4] <= q[1] ^ q[0]; // Feedback from tap positions
        q[3] <= q[4]; // Shift
        q[2] <= q[3]; // Shift
        q[1] <= q[2]; // Shift
        q[0] <= q[1]; // Shift (XOR with itself, essentially no change, but needed for code flow)
    end
end

endmodule