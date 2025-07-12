module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;

// Multiplexer to select next value of Q
assign next_Q = L ? R : (E ? w : Q);

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule