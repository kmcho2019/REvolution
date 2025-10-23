module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;

always @(posedge clk) begin
    if (b == 1'b0) begin
        stateReg <= 1'b0;
    end else if (a == 1'b1) begin
        stateReg <= ~stateReg;
    end
end

assign q = stateReg;
assign state = stateReg;

endmodule