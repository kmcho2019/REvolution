module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire [3:0] next_out;

// Combinational next-state logic
assign next_out = (!rst_n) ? 4'b0000 :          // Reset condition
                  (valid_count) ?                // Counting enabled
                    (out == 4'd11) ? 4'b0000 :   // Wrap-around
                    out + 1'b1 :                 // Increment
                  out;                           // Hold value

// Sequential state storage
always @(posedge clk) begin
    out <= next_out;
end

endmodule