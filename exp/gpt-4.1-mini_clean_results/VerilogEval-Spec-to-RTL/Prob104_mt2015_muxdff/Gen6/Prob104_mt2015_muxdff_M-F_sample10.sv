module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

wire mux_out;
assign mux_out = L ? r_in : q_in;

initial begin
    Q = 1'b0;
end

always @(posedge clk) begin
    Q <= mux_out;
end

endmodule