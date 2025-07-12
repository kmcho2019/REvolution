module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @ (posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q[4] <= q[0] ^ q[2];
        q[3:0] <= q[3:1];
    end
end

endmodule