module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;

// Priority-encoded multiplexer:
// L has highest priority, then E, else hold current value
assign next_Q = L ? R : (E ? w : Q);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule