module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire next_state;
wire load_or_shift;

// First mux: Load has priority over shift
assign load_or_shift = L ? R : w;

// Second mux: Enable controls whether to update or hold
assign next_state = (L || E) ? load_or_shift : Q;

// Sequential element
DFF dff_inst (
    .clk(clk),
    .D(next_state),
    .Q(Q)
);

endmodule

// Simple D-flipflop primitive
module DFF (
    input clk,
    input D,
    output reg Q
);
always @(posedge clk) begin
    Q <= D;
end
endmodule