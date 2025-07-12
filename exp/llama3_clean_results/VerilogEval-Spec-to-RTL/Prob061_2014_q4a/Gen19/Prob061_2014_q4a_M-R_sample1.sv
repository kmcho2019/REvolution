module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Combinational logic to determine the next state of Q
wire next_Q;
assign next_Q = (L)? R : (E)? w : Q;

// Sequential logic to update Q on the positive edge of the clock
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule