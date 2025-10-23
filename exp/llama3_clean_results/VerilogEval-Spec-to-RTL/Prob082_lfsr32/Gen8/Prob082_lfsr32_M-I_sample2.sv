module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the new MSB based on the taps and the current LSB
        q <= {q[0] ^ q[21] ^ q[1] ^ q[0], q[31:1]};
    end
end

endmodule