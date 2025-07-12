module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: 31 (32), 21 (22), 1 (2), 0 (1)
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {q[0] ^ q[31], q[30:22], q[21] ^ q[0], q[20:2], q[1] ^ q[0], q[0]};
    end
end

endmodule