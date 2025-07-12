module TopModule (
    input  clk,
    input  reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;
    localparam ROLL_OVER = 10'd1000;

    wire [9:0] next_count = q + 10'd1;

    // Check if next_count equals roll-over value
    wire roll_over_reached = (next_count == ROLL_OVER);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (roll_over_reached) begin
            q <= 10'd0;
        end else begin
            q <= next_count;
        end
    end

endmodule