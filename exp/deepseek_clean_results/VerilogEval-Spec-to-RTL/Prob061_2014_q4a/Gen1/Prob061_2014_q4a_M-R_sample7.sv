module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire next_Q;
reg current_Q;

// Combinational next-state logic
assign next_Q = L ? R : (E ? w : current_Q);

// Sequential element
always @(posedge clk) begin
    current_Q <= next_Q;
end

// Output assignment
assign Q = current_Q;

endmodule