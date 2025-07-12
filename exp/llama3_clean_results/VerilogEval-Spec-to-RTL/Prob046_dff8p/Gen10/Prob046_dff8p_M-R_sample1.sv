module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Combinational logic to select between input d and reset value
wire [7:0] sel_value = reset ? 8'd52 : d;

// Sequential logic to update output q
always @(negedge clk) begin
    q <= sel_value;
end

endmodule