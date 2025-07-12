module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1;
    end else begin
        q <= {q[3:0], q[4] ^ q[2]};
    end
end

endmodule