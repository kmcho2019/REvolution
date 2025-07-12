module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire next_Q;

// Combinational logic for next state
assign next_Q = L ? R : (E ? w : Q);

// Sequential element
dff dff_inst (
    .clk(clk),
    .d(next_Q),
    .q(Q)
);

endmodule

// Flip-flop primitive
module dff (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule