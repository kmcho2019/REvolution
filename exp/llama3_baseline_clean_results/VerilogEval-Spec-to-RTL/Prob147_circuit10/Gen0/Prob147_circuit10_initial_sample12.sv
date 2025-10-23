module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg stateReg; // One-bit flip-flop
assign state = stateReg;

always @(posedge clk) begin
    if (a && b) begin // Reset state when a and b are 1
        stateReg <= 0;
    end else if (!a && !b) begin // Set state when a and b are 0
        stateReg <= 1;
    end
end

assign q = (!a && b) || stateReg; // Output q is 1 when a is 0 and b is 1, or when state is 1

endmodule