module TopModule(
    input clk,
    input in,
    output reg out
);

reg prev_out;

// Combinational logic for XOR operation
always @(*) begin
    out = in ^ prev_out;
end

// Sequential logic for D flip-flop
always @(posedge clk) begin
    prev_out <= in ^ prev_out;
end

endmodule