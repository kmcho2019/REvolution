module BasicDFF (
    input  clk,
    input  d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

wire d_gated;

// Reset logic: gate the input when reset is active
assign d_gated = r ? 1'b0 : d;

// Instantiate the basic D flip-flop
BasicDFF dff_inst (
    .clk(clk),
    .d(d_gated),
    .q(q)
);

endmodule