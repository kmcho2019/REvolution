module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b1;
    end else begin
        q <= {q[3] ^ q[0], q[2], q[1], q[0], q[4] ^ q[3]};
    end
end

endmodule