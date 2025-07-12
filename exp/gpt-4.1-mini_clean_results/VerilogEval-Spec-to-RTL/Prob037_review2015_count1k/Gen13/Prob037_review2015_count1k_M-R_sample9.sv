module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    // Partial terminal count detection
    wire upper_match = (q[9:7] == MAX_COUNT[9:7]);
    wire lower_match = (q[6:0] == MAX_COUNT[6:0]);
    wire is_max_count = upper_match & lower_match;

    reg [9:0] next_q;

    // Combinational next state logic
    always @(*) begin
        if (is_max_count)
            next_q = 10'd0;
        else
            next_q = q + 10'd1;
    end

    // Sequential logic: register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule