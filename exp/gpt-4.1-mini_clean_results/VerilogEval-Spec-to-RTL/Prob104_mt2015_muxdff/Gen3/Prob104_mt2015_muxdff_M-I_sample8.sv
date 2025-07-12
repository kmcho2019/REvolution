module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

wire mux_out;

// Combinational 2:1 mux selecting between load and feedback
assign mux_out = L ? r_in : q_in;

// Flip-flop capturing mux output on positive edge of clk
always @(posedge clk) begin
    Q <= mux_out;
end

endmodule