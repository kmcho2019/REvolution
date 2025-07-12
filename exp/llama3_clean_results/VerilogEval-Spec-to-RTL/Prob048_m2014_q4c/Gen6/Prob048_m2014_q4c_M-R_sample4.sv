module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg q_next;

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule