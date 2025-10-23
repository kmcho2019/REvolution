module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    // Next counter value computed with continuous assignment
    wire [9:0] next_q = (q == MAX_COUNT) ? 10'd0 : q + 10'd1;

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule