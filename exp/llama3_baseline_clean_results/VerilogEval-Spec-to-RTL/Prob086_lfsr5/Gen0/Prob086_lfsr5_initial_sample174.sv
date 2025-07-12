module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b10000;
    end else begin
        q <= {q[3:0], q[4] ^ q[2] ^ q[0]};
    end
end

endmodule