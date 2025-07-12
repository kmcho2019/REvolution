module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output wire [3:0] out      // 4-bit counter output
);

reg [3:0] counter_reg;
reg valid_count_reg;

// Register input signals for better timing
always @(posedge clk) begin
    valid_count_reg <= valid_count;
end

// Next state logic with explicit wrap detection
wire [3:0] next_count = (!rst_n) ? 4'b0000 : 
                       (valid_count_reg && (counter_reg == 4'd11)) ? 4'b0000 :
                       (valid_count_reg) ? counter_reg + 1'b1 :
                       counter_reg;

// Sequential logic with clock enable
always @(posedge clk) begin
    if (!rst_n) begin
        counter_reg <= 4'b0000;
    end else if (valid_count_reg) begin
        counter_reg <= next_count;
    end
end

assign out = counter_reg;

endmodule