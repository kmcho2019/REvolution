module TopModule(
    output out
);

parameter OUT_VALUE = 1'b0;

always @(*) begin
    out = OUT_VALUE;
end

endmodule