module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Direct assignment for next state logic
wire next_Q;
assign next_Q = (L ? R : (E ? w : Q));

// Clock-gated always block for updating Q, considering both L and E conditions
always @(posedge clk) begin
    if (L || E) begin
        Q <= next_Q;
    end
end

endmodule