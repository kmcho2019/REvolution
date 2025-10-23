module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;

// Combinational logic for next state
assign next_Q = L ? R : (E ? w : Q);

// Sequential element
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule