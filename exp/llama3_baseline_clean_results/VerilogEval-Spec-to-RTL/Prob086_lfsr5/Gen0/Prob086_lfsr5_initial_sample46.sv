module TopModule (
    input  clk,
    input  reset,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b10000;
    end else begin
        q[4] <= q[3];
        q[3] <= q[2] ^ q[0];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= q[4] ^ q[0];
    end
end

endmodule