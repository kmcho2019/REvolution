module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out       // Counter output
);

wire [3:0] next_out;

// Continuous assignment for next state logic
assign next_out = (!rst_n) ? 4'b0000 : 
                 (valid_count) ? ((out == 4'b1011) ? 4'b0000 : out + 1) : 
                 out;

// Sequential logic for state transition
always @(posedge clk) begin
    out <= next_out;
end

endmodule