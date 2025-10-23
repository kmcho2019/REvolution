module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

wire [3:0] next_count = out + 1'b1;
wire count_max = (out == 4'b1011);  // Detect when count reaches 11
wire [3:0] mux_out;

// Parallel load mux
assign mux_out = (!rst_n) ? 4'b0000 : 
                 (count_max) ? 4'b0000 : 
                 next_count;

// Sequential logic with clock enable
always @(posedge clk) begin
    if (valid_count || !rst_n) begin
        out <= mux_out;
    end
end

endmodule