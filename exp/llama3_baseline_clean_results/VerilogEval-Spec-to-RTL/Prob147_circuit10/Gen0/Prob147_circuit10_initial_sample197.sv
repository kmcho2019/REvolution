module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg;

assign q = (b && !state) || (a && b && state);

always @(posedge clk) begin
    if(!b) begin
        stateReg <= a;
    end
end

assign state = stateReg;

endmodule