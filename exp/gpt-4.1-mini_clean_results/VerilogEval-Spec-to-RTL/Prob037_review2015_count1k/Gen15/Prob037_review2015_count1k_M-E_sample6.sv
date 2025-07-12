module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT_PLUS_ONE = 10'd1000;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            if (q + 10'd1 == MAX_COUNT_PLUS_ONE) begin
                q <= 10'd0;
            end else begin
                q <= q + 10'd1;
            end
        end
    end

endmodule