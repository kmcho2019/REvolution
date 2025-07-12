module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1;
    end else begin
        q[4] <= q[3]; // Shift bit at position 4
        q[3] <= q[2] ^ q[0]; // Tap at position 3
        q[2] <= q[1]; // Shift bit at position 2
        q[1] <= q[0]; // Shift bit at position 1
        q[0] <= q[4] ^ q[2] ^ q[0]; // Tap at position 5 (index 4)
    end
end

endmodule