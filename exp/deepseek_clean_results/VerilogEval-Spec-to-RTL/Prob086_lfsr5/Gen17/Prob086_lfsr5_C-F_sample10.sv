module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) q <= 5'b00001;
    else q <= {q[0], q[4], q[3] ^ q[0], q[2:1]};
end

endmodule