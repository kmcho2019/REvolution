module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    if (!j &&!k) Q <= Q;
    else if (!j && k) Q <= 1'b0;
    else if (j &&!k) Q <= 1'b1;
    else Q <= ~Q;
end

endmodule