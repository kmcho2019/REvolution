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
    if (~a && b || (stateReg && a && b)) begin
        stateReg <= 1'b1;
    end else begin
        stateReg <= 1'b0;
    end
end

assign q = (~a && b) || stateReg;

endmodule