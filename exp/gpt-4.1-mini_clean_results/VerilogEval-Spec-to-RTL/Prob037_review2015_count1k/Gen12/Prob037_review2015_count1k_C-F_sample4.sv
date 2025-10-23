module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for terminal count
    localparam MAX_COUNT = 10'd999;

    // Partial comparator to detect MAX_COUNT: split into upper and lower bits
    wire upper_match = (q[9:7] == MAX_COUNT[9:7]);
    wire lower_match = (q[6:0] == MAX_COUNT[6:0]);
    wire is_max_count = upper_match & lower_match;

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else if (is_max_count)
            q <= 10'd0;
        else
            q <= q + 10'd1;
    end

endmodule