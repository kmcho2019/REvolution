module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic to determine the next state, prioritizing operations to minimize delay
reg next_Q;
always @(*) begin
    case ({j, k})
        2'b00: next_Q = Q; // No change
        2'b01: next_Q = 1'b0; // Reset
        2'b10: next_Q = 1'b1; // Set
        2'b11: next_Q = ~Q; // Toggle
    endcase
end

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule