module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire next_Q;

// Combinational mux logic
assign next_Q = L ? R : (E ? w : Q);

// Sequential element
dff d_flipflop (
    .clk(clk),
    .d(next_Q),
    .q(Q)
);

endmodule

// Simple D-flipflop module
module dff (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule