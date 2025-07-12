module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

// Combinational logic to determine the next state
always @(*) begin
    Q <= (j && k) ? ~Q : (j && ~k) ? 1'b1 : (~j && k) ? 1'b0 : Q;
end

endmodule