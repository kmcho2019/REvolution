module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= {q[2:0], q[3] ^ q[0]};
    end
end

endmodule