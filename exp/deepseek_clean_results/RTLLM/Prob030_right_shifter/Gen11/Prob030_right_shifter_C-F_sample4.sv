module right_shifter (
    input wire clk,
    input wire d,
    input wire enable = 1'b1,  // Optional clock gating (default on)
    input wire reset_n,        // Active-low synchronous reset
    output reg [7:0] q
);

// Clock gating with enable
wire gated_clk;
assign gated_clk = clk & enable;

always @(posedge gated_clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;            // Synchronous reset
    end else begin
        q <= {d, q[7:1]};     // Efficient right shift with MSB insertion
    end
end

endmodule