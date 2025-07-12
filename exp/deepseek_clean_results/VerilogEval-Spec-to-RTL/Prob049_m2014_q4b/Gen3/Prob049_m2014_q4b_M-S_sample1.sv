module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

assign q = ar ? 1'b0 : (clk ? d : q);

endmodule