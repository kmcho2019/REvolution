module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg master_latch;

always @(posedge clk) begin
    if (r) begin
        master_latch <= 0;
        q <= 0;
    end else begin
        master_latch <= d;
        q <= master_latch;
    end
end

endmodule