module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// Next state logic
wire [3:0] next_out;
assign next_out = (!rst_n) ? 4'b0000 : 
                 (valid_count) ? ((out == 4'b1011) ? 4'b0000 : out + 1'b1) : 
                 out;

// Sequential logic
always @(posedge clk) begin
    out <= next_out;
end

endmodule