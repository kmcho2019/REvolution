module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire mux1_out;
wire mux2_out;

// First mux: Select between shift input (w) or hold current value (Q)
assign mux1_out = E ? w : Q;

// Second mux: Select between load value (R) or result from first mux
assign mux2_out = L ? R : mux1_out;

// Register the final output
always @(posedge clk) begin
    Q <= mux2_out;
end

endmodule