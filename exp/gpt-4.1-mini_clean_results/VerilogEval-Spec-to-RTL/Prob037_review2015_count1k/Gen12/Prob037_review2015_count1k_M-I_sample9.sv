module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for terminal count
    localparam [9:0] MAX_COUNT = 10'd999;

    // Compare q with MAX_COUNT using arithmetic equality
    wire is_max_count = (q == MAX_COUNT);

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= is_max_count ? 10'd0 : q + 10'd1;
    end

endmodule