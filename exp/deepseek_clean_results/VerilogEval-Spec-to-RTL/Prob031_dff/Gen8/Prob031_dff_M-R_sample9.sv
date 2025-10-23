module TopModule (
    input clk,
    input d,
    output reg q
);

wire d_input;

assign d_input = d;  // Explicit wire assignment (could be omitted)

always @(posedge clk) begin
    q <= d_input;    // Same flip-flop behavior using the intermediate wire
end

endmodule