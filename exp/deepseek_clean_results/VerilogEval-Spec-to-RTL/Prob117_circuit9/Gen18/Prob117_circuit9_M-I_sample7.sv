module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire enable = ~a;  // Only update counter when a is low
wire [2:0] next_count = (q == 3'd6) ? 3'd0 : q + 1'b1;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Constant output when a is high
    end
    else if (enable) begin
        q <= next_count;  // Increment counter when enabled
    end
end

endmodule