module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

wire mux_out;

// 2:1 MUX: if L=1 select q_in, else select r_in
assign mux_out = L ? q_in : r_in;

// D flip-flop: store mux_out on posedge clk
always @(posedge clk) begin
    Q <= mux_out;
end

endmodule