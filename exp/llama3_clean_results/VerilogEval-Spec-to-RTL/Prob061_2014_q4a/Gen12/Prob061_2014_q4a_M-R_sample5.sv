module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Define the next state logic using assign
wire next_Q;
assign next_Q = (L) ? R : (E) ? w : Q;

// Clock-gated always block to update Q
always @(posedge clk) begin
    if (L || E) begin
        Q <= next_Q;
    end
end

endmodule