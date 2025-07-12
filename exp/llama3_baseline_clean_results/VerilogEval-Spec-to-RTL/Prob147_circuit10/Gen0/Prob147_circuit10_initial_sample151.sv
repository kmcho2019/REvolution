module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;

always @(posedge clk)
begin
    if (~a & b) 
        stateReg <= 1;
    else if (~a & ~b)
        stateReg <= 0;
    else if (a & ~b) 
        stateReg <= 1;
    else
        stateReg <= ~stateReg;
end

assign state = stateReg;

assign q = (a & b & stateReg) | (~a & b) | (a & ~b);

endmodule