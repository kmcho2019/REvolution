module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter COUNTER_WIDTH = 10;
parameter MAX_COUNT = 10'd999;

// Optimized terminal count detection
wire upper_bits_match = (q[9:3] == 7'b1111011); // 987-999 (0x3DB-0x3E7)
wire lower_bits_match = (q[2:0] == 3'b111);     // Last 3 bits = 7
wire terminal_count = (q == MAX_COUNT);         // Direct comparison for clarity

always @(posedge clk) begin
    if (reset) begin
        q <= {COUNTER_WIDTH{1'b0}};
    end else if (terminal_count) begin
        q <= {COUNTER_WIDTH{1'b0}};
    end else begin
        q <= q + 1'b1;
    end
end

endmodule