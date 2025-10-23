module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire counter_en = ~a;
wire counter_rst = (q == 3'd6);
wire [2:0] next_count = q + 1'b1;  // Simple increment without conditional

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Direct assignment when a is high
    end else if (counter_en) begin
        q <= counter_rst ? 3'd0 : next_count;  // Conditional wrap-around
    end
end

endmodule