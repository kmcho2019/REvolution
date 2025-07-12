module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// Next state computation in parallel
wire [3:0] next_count = out + 1'b1;
wire wrap_around = &out[2:0] & out[3];  // Detects 1011 (11) using bitwise AND

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        // Parallel load approach - mux selects between increment or wrap
        out <= wrap_around ? 4'b0000 : next_count;
    end
    // else hold current value (implicit)
end

endmodule