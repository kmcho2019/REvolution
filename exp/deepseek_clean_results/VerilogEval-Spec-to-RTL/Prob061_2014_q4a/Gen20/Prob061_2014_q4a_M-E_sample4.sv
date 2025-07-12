module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

// Control unit - combinational logic only
wire next_Q;
assign next_Q = L ? R : (E ? w : Q);

// Storage element - simple D flip-flop
DFF dff_inst (
    .clk(clk),
    .D(next_Q),
    .Q(Q)
);

endmodule

// Basic D Flip-Flop module
module DFF (
    input clk,
    input D,
    output reg Q
);
always @(posedge clk) begin
    Q <= D;
end
endmodule