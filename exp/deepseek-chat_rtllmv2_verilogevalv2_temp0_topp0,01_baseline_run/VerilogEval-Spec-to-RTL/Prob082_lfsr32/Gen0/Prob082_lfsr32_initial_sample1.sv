module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Galois LFSR with taps at positions 32,22,2,1 (q[31],q[21],q[1],q[0])
        q <= {q[0], q[31:22] ^ {8{q[0]}}, q[21:2] ^ {20{q[0]}}, q[1] ^ q[0]};
    end
end

endmodule