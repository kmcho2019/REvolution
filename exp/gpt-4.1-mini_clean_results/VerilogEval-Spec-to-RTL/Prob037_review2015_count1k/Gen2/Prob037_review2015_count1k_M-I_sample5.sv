module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] count_down;

    always @(posedge clk) begin
        if (reset) begin
            count_down <= 10'd999;
            q <= 10'd0;
        end else begin
            if (count_down == 10'd0) begin
                count_down <= 10'd999;
                q <= 10'd0;
            end else begin
                count_down <= count_down - 10'd1;
                q <= q + 10'd1;
            end
        end
    end

endmodule