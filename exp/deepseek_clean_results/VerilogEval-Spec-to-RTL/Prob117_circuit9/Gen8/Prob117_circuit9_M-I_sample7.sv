module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_count = (q == 3'd6) ? 3'd0 : q + 1'b1;
wire count_enable = ~a;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else if (count_enable) begin
        q <= next_count;
    end
end

endmodule