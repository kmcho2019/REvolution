module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b1;  // Reset the LFSR output to 1
    end else begin
        q <= {q[3:0], q[4] ^ q[2]};  // Update LFSR state based on taps
    end
end

endmodule