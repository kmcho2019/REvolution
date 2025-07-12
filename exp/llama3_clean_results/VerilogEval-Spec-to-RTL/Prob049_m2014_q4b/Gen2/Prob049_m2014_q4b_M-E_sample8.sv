module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg stage1_out;

always @(*) begin
    if (ar) begin
        stage1_out = 1'b0; // Asynchronous reset
    end else begin
        stage1_out = d; // Pass input d to the next stage
    end
end

always @(posedge clk) begin
    q <= stage1_out; // Capture stage1_out on positive edge of clk
end

endmodule