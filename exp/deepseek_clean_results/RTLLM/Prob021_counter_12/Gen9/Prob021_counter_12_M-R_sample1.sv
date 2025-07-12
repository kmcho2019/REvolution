module counter_12 (
    input wire rst_n,          // Active low reset (synchronous)
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output wire [3:0] out      // 4-bit counter output
);

reg [3:0] counter_reg;

// Next state logic
wire [3:0] next_count = (!rst_n) ? 4'b0000 : 
                       (valid_count) ? counter_reg + 1'b1 : 
                       counter_reg;

// Register update
always @(posedge clk) begin
    counter_reg <= next_count;
end

// Output assignment
assign out = counter_reg;

endmodule