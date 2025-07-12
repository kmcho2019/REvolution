module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    parameter MAX_COUNT = 10'd999;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            if (q < MAX_COUNT)
                q <= q + 10'd1;
            else
                q <= 10'd0;
        end
    end

endmodule