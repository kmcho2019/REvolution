module TopModule(
    input  clk,
    input  d,
    output q
);

reg posSample;
reg negSample;
reg qReg;

always @(posedge clk) begin
    qReg <= posSample;
end

always @(negedge clk) begin
    negSample <= d;
end

always @(posedge clk) begin
    posSample <= d;
end

assign q = qReg;

initial begin
    posSample = 1'b0;
    negSample = 1'b0;
    qReg = 1'b0;
end

endmodule