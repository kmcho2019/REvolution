module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg q_reg; // Register to hold the state of q

// D flip-flop for q
always @(posedge ~clock) begin
    q_reg <= a;
end

assign q = q_reg;

// AND gate for p
assign p = clock && a;

endmodule