module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;
assign state = stateReg;

always @(posedge clk) begin
    stateReg <= ~a & b | (a & ~b & stateReg);
end

assign q = ~a & b | (a & ~b & stateReg);

endmodule