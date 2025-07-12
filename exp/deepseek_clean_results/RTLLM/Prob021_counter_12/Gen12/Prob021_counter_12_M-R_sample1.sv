module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output wire [3:0] out      // 4-bit counter output
);

reg [3:0] count_reg;
wire [3:0] next_count;

// Next state logic
assign next_count = (count_reg == 4'd11) ? 4'b0000 : 
                   (count_reg + 1'b1);

// State registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count_reg <= 4'b0000;
    end else if (valid_count) begin
        count_reg <= next_count;
    end
end

// Output assignment
assign out = count_reg;

endmodule