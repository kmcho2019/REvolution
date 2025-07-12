module TopModule(
    output zero
);

parameter OUTPUT_VALUE = 1'b0;

always @(zero) begin
    zero = OUTPUT_VALUE;
end

endmodule