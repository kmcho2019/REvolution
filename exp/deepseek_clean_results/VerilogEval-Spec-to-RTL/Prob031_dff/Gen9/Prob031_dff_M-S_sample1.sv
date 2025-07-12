module TopModule(
    input clk,
    input d,
    output q
);
    always_ff @(posedge clk) q <= d;
endmodule