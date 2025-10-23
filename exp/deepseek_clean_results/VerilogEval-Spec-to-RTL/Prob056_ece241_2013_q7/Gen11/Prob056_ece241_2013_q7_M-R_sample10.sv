module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Q_next;

// Combinational next-state logic
assign Q_next = (j & ~k) ? 1'b1 :
                (~j & k) ? 1'b0 :
                (j & k) ? ~Q : Q;

// Sequential state storage
always @(posedge clk) begin
    Q <= Q_next;
end

endmodule