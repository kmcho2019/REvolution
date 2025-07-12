module TopModule (
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
    end else if (!a && !b) begin
        stateReg <= 0;
    end else if (!a && b) begin
        if (!stateReg) begin
            stateReg <= 1;
        end
    end
end

assign q = (stateReg) ? ~a : b;

endmodule