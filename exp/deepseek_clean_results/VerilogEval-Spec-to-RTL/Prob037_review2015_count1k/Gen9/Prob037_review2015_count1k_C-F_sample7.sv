module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter COUNTER_WIDTH = 10;
parameter MAX_COUNT = 10'd999;

// Efficient terminal count detection
wire upper_bits_match = (q[9:5] == 5'b11111);  // Upper 5 bits = 31 (992-1023)
wire lower_bits_match = (q[4:0] == 5'b00111);  // Lower 5 bits = 7
wire terminal_count = upper_bits_match & lower_bits_match;

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