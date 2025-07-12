module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

// Combinational mux selects input based on load enable L
wire d = (L) ? r_in : q_in;

// Register the mux output on rising edge of clk
always @(posedge clk) begin
    Q <= d;
end

endmodule