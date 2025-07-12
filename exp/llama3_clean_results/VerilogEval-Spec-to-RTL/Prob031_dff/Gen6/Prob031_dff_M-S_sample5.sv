module TopModule(
    input clk,
    input d,
    output q
);

always @(posedge clk) begin
    q <= d;
end

endmodule