module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output reg [7:0] q
);

// Clock gating implementation
wire gated_clk = clk & enable;

// Combinational shift operation
wire [7:0] shifted_val = {d, q[7:1]};

// Sequential update
always @(posedge gated_clk) begin
    q <= shifted_val;
end

endmodule