module TopModule(
    input clk,
    input d,
    output reg q
);

reg master_latch_output;

always @(clk or d) begin
    if (!clk) begin
        master_latch_output <= d;
    end
end

always @(posedge clk) begin
    q <= master_latch_output;
end

endmodule