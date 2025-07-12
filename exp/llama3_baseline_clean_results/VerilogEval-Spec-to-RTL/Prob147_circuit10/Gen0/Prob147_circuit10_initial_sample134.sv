module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;

always @(posedge clk) begin
    stateReg <= b;
end

assign state = stateReg;
assign q = (b && !stateReg) || (a && b && stateReg);

endmodule