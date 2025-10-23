module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg latch_out;

always @(negedge clk) begin
    latch_out <= d;
end

always @(posedge clk) begin
    if (r) begin
        q <= 0;
    end else begin
        q <= latch_out;
    end
end

endmodule