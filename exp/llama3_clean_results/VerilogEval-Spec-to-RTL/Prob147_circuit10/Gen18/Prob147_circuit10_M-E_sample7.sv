module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;
always @(posedge clk) begin
    if (a && b) begin
        stateReg <= ~stateReg;
    end else if (!a && b) begin
        stateReg <= 1'b1;
    end else if (a && !b) begin
        stateReg <= 1'b0;
    end else begin
        stateReg <= stateReg;
    end
end

assign q = a ^ b;
assign state = stateReg;

initial begin
    stateReg = 1'b0;
end

endmodule