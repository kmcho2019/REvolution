module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg stateReg;
assign state = stateReg;

always @(posedge clk) begin
    if (a) begin
        stateReg <= b;
    end
end

assign q = (state == 0) ? b : ~b;

endmodule