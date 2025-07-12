module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output wire [3:0] out      // 4-bit counter output
);

reg [3:0] count_reg;
wire [3:0] next_count;

// Next state logic
assign next_count = (!rst_n) ? 4'b0000 : 
                   (valid_count) ? (count_reg + 1'b1) : 
                   count_reg;

// Register update
always @(posedge clk) begin
    count_reg <= next_count;
end

// Output assignment
assign out = count_reg;

endmodule