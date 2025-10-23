module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Control signals
wire count_enable = (q != END);  // Enable counting when not at max value
wire [3:0] next_count = q + 4'b0001;

// Sequential logic with integrated reset
always @(posedge clk) begin
    if (reset) begin
        q <= START;
    end
    else if (count_enable) begin
        q <= next_count;
    end
    // Implicit else: hold value when at max count
end

endmodule