module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output q
);

reg q_reg;
wire next_q;

// Combinational logic to determine next state of q_reg
assign next_q = d;

// Asynchronous reset logic handled in a separate always block
always @(posedge clk or posedge ar) begin
    if (ar)
        q_reg <= 1'b0;     // asynchronous reset: immediate zero
    else
        q_reg <= next_q;   // synchronous data update
end

assign q = q_reg;

endmodule