module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;
assign state = stateReg;
assign q = (a == 0 && b == 1) || (a == 1 && b == 0);

always @(posedge clk) begin
    if (a == 0 && b == 1) begin
        stateReg <= 0;
    end else if (a == 1 && b == 1) begin
        stateReg <= ~stateReg;
    end else if (a == 0 && b == 0) begin
        stateReg <= 1;
    end else if (a == 1 && b == 0) begin
        stateReg <= ~stateReg;
    end
end

endmodule