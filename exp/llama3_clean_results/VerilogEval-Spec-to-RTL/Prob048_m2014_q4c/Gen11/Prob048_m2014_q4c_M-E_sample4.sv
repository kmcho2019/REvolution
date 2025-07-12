module TopModule(
    input  logic clk,
    input  logic d,
    input  logic r,
    output logic q
);

logic stage1_data;

always @(posedge clk) begin
    stage1_data <= r ? 1'b0 : d;
end

always @(posedge clk) begin
    q <= stage1_data;
end

endmodule