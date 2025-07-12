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
    case({a, b})
        2'b01: stateReg <= 1'b1;
        2'b11: stateReg <= 1'b0;
        default: stateReg <= stateReg;
    endcase
end

assign q = stateReg;

endmodule