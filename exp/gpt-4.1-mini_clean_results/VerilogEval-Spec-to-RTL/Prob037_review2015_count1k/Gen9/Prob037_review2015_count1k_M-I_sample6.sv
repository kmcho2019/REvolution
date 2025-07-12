module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            q <= (q == MAX_COUNT) ? 10'd0 : q + 10'd1;
        end
    end

endmodule