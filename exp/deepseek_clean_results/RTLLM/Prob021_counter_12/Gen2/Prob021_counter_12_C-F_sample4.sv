module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

// Combinational next-state logic
wire [3:0] next_out = (!rst_n) ? 4'b0000 :          // Async reset
                     (valid_count && (out == 4'b1011)) ? 4'b0000 : // Wrap-around
                     (valid_count) ? out + 1'b1 :    // Increment
                     out;                           // Hold value

// Sequential state storage
always @(posedge clk) begin
    out <= next_out;
end

endmodule