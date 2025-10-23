module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Next state calculation (combinational logic)
wire [3:0] next_count;
assign next_count = reset       ? 4'b0000 :  // Synchronous reset
                    (q == 4'b1001) ? 4'b0000 :  // Clear check for 9 (1001)
                    q + 1'b1;              // Normal increment

// State register (sequential logic)
always @(posedge clk) begin
    q <= next_count;
end

endmodule