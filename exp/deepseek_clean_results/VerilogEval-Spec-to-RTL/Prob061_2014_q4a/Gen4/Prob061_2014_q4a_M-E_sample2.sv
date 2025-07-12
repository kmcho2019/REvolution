module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg state;
wire next_state;

// Next state logic - explicit priority encoding
assign next_state = L ? R : (E ? w : state);

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Continuous output assignment
assign Q = state;

endmodule