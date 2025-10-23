module TopModule(
    input clk,
    input d,
    output reg q
);

reg master_latch_out;

always @(clk or d) begin
    if (clk) begin
        master_latch_out <= d;
    end
end

always @(negedge clk) begin
    q <= master_latch_out;
end

endmodule