module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire next_Q;

// Optimized combinational logic using case statement
assign next_Q = ({j,k} == 2'b00) ? Q_reg :
                ({j,k} == 2'b01) ? 1'b0 :
                ({j,k} == 2'b10) ? 1'b1 :
                ~Q_reg; // {j,k} == 2'b11

// Sequential element (D flip-flop)
always @(posedge clk) begin
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule