module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;

always @ (posedge clk) begin
    stateReg <= (~b & stateReg) | (a & ~stateReg);
end

assign state = stateReg;
assign q = a | state;

endmodule