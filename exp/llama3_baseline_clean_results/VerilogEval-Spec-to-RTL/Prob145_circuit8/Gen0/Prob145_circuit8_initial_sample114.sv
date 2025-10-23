module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg pReg;
reg qReg;

assign p = pReg;
assign q = qReg;

initial begin
    pReg = 0;
    qReg = 0;
end

always @(posedge clock) begin
    if(a) begin
        pReg <= 1;
        qReg <= qReg | a;
    end else begin
        pReg <= 0;
    end
end

always @(negedge clock) begin
    if(!a) begin
        qReg <= 0;
    end
end

endmodule