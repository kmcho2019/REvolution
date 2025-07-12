module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg reset_value;

always @(*) begin
    reset_value = r ? 1'b0 : d; // Combinational logic for reset-conditioned input
end

always @(posedge clk) begin
    q <= reset_value; // Basic D flip-flop capturing the reset-conditioned input
end

endmodule