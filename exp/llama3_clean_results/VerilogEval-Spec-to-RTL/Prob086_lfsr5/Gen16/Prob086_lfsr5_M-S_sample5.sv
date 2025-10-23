module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q[4] <= q[2] ^ q[0]; // Tap positions
        q[3] <= q[4]; // Shift
        q[2] <= q[3]; // Shift
        q[1] <= q[2]; // Shift
        q[0] <= q[1]; // Shift
    end
end

endmodule