module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam [9:0] MAX_COUNT = 10'd999;

    wire is_max_count = (q == MAX_COUNT);
    wire [9:0] next_q = is_max_count ? 10'd0 : (q + 10'd1);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            q <= next_q;
        end
    end

endmodule