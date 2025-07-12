module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

// Combinational 2:1 mux selecting between load (r_in) and feedback (q_in)
wire mux_out = L ? r_in : q_in;

// Flip-flop capturing mux output on positive edge of clk
always @(posedge clk) begin
    Q <= mux_out;
end

// Initialize Q to zero to avoid unknown initial state in simulation
initial begin
    Q = 1'b0;
end

endmodule