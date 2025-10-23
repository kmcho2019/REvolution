module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

    wire count_enable = (q != 10'd999);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (count_enable) begin
            q <= q + 10'd1;
        end else begin
            q <= 10'd0;
        end
    end

endmodule