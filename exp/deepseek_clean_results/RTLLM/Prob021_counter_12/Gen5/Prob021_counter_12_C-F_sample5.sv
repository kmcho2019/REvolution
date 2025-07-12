module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// Compute next state only when needed
wire [3:0] next_count;
wire count_max;

assign next_count = out + 1'b1;
assign count_max = (out == 4'b1011);  // Efficient terminal count detection

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;       // Synchronous reset
    end
    else if (valid_count) begin
        out <= count_max ? 4'b0000 : next_count;  // Parallel mux
    end
    // else hold current value
end

endmodule