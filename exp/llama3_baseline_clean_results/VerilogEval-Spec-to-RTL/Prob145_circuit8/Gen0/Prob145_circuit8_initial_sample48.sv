module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg qReg;

assign p = clock && a;
always @(posedge clock) begin
    if (a) begin
        qReg <= 1'b1;
    end
end

always @(negedge clock) begin
    if (!a) begin
        qReg <= 1'b0;
    end
end

assign q = qReg;

endmodule