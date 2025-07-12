module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for terminal count
    localparam [9:0] MAX_COUNT = 10'd999;

    // Partitioned terminal count detection
    wire upper_match = (q[9:7] == MAX_COUNT[9:7]);
    wire lower_match = (q[6:0] == MAX_COUNT[6:0]);
    wire is_max_count = upper_match & lower_match;

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= is_max_count ? 10'd0 : q + 10'd1;
    end

endmodule