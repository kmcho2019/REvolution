module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

wire mux_out;

// 2:1 MUX: select r_in when L=1 else q_in
assign mux_out = L ? r_in : q_in;

// D flip-flop with positive-edge clock
always @(posedge clk) begin
    Q <= mux_out;
end

endmodule