module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;
assign state = stateReg;

always @ (posedge clk) begin
    if (a && b) begin
        stateReg <= ~stateReg;
    end else begin
        stateReg <= stateReg;
    end
end

assign q = (b && !stateReg) || (a && b && stateReg);

endmodule