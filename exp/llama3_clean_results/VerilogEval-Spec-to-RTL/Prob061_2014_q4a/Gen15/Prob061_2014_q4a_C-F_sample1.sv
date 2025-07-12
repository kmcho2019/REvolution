module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Use a 2:1 multiplexer to select between R and w based on L and E
wire mux_out;
assign mux_out = (L) ? R : ((E) ? w : Q);

// Sequential logic to update Q based on mux_out
always @(posedge clk) begin
    Q <= mux_out;
end

endmodule