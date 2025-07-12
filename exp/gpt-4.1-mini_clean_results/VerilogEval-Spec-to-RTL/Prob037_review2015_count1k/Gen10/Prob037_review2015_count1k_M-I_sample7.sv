module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    // Sequential state update with synchronous reset and inline next-state calculation
    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= (q == MAX_COUNT) ? 10'd0 : q + 10'd1;
    end

endmodule