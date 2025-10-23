module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        // Compact shift register with XOR tap at bit 2
        q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    end
end

endmodule