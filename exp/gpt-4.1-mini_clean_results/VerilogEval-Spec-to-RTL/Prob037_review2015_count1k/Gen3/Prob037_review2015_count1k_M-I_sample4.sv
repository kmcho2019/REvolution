module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for max count
    parameter MAX_COUNT = 10'd999;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            // If counter less than MAX_COUNT, increment; else wrap to 0
            q <= (q < MAX_COUNT) ? q + 10'd1 : 10'd0;
        end
    end

endmodule