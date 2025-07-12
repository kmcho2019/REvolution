module TopModule(
    input clk,
    input a,
    output logic q
);

always @(posedge clk) begin
    q <= ~a;
end

endmodule