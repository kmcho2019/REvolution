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
    if (~a & ~b) begin
        stateReg <= 1;
    end else if (a & b) begin
        stateReg <= 0;
    end else begin
        stateReg <= stateReg;
    end
end

assign q = (~stateReg & b) | (stateReg & ~b);

endmodule