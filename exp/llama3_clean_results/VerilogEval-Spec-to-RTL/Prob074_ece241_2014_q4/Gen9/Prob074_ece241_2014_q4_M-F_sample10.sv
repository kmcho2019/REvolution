module TopModule(
    input clk,
    input x,
    output reg z
);

reg q_xor, q_and, q_or;

// Combinational logic for gate outputs
wire xor_out, and_out, or_out;
assign xor_out = x ^ q_xor;
assign and_out = x & ~q_and;
assign or_out = x | ~q_or;

// Sequential logic for updating state
always @(posedge clk or negedge clk) begin
    if (~clk) begin
        q_xor <= 0;
        q_and <= 0;
        q_or <= 0;
    end else begin
        q_xor <= xor_out;
        q_and <= and_out;
        q_or <= or_out;
    end
end

// Combinational logic for computing z
assign z = ~(xor_out | and_out | or_out);

endmodule