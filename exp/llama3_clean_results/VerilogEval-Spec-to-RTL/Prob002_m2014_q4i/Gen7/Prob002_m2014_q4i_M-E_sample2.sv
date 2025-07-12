module TopModule(
    output out
);

reg out_reg;
assign out = out_reg;

initial begin
    out_reg = 1'b0;
end

always @(posedge 1'b0) begin
    out_reg <= 1'b0;
end

endmodule