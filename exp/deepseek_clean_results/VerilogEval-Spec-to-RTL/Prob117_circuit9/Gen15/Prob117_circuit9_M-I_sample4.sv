module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire counter_en = ~a;
wire counter_rst = (q == 3'd6);
wire [2:0] next_count = counter_rst ? 3'd0 : q + 1'b1;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else if (counter_en) begin
        q <= next_count;
    end
end

endmodule