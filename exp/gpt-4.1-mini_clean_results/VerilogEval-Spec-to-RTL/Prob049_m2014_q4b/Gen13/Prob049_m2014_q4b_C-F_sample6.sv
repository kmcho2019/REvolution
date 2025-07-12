module TopModule (
    input  clk,
    input  ar,      // Asynchronous active-high reset
    input  d,
    output q
);

reg q_reg;

// Initialize q_reg to zero at simulation start for known state (ignored by synthesis)
initial q_reg = 1'b0;

// Positive-edge triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar)
        q_reg <= 1'b0;   // Asynchronous reset active high
    else
        q_reg <= d;      // Capture input d on clock edge
end

// Output driven continuously from internal register
assign q = q_reg;

endmodule