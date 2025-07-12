module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for terminal count
    localparam MAX_COUNT = 10'd999;

    // Detect terminal count using subtraction zero detect
    wire at_max_count = (q == MAX_COUNT);

    // Enable counting only when not at max count or during reset
    wire enable = ~at_max_count;

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else if (enable)
            q <= q + 10'd1;
        else
            q <= 10'd0; // reset at terminal count to 0 in next cycle
    end

endmodule