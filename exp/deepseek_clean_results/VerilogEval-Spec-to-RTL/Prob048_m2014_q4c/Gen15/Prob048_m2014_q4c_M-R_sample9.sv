module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_reg;
wire next_q;

// Combinational logic for next state
assign next_q = r ? 1'b0 : d;

// Sequential element
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule