module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Control signals
wire count_enable;
wire [3:0] next_state;

// Enable counter only when not at terminal value
assign count_enable = (q != END);

// Next state logic
assign next_state = reset ? START :         // Reset condition
                   (q == END) ? START :     // Terminal condition
                   q + 4'b0001;             // Normal increment

// Sequential logic with clock enable
always @(posedge clk) begin
    if (count_enable || reset) begin
        q <= next_state;
    end
end

endmodule