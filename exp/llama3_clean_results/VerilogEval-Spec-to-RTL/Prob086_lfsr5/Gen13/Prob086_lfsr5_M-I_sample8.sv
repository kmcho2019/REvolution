module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Set the LFSR output to 1
    end else begin
        q[4] <= q[2] ^ q[0]; // Tap at position 4
        q[3] <= q[4]; // Shift
        q[2] <= q[1] ^ q[0]; // Tap at position 2
        q[1] <= q[0]; // Shift
        q[0] <= q[4]; // Shift
    end
end

endmodule