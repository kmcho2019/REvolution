module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

wire Q_next = (j & ~Q) | (~k & Q) | (j & k & ~Q); 
// The above expression simplifies to: (j & ~Q) | (~k & Q)
// but to explicitly show toggle case, one could also use:
// Q_next = (j & ~k) ? 1'b1 : (~j & k) ? 1'b0 : (j & k) ? ~Q : Q;

// Using standard characteristic equation:
wire Q_next_calc = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= Q_next_calc;
end

endmodule