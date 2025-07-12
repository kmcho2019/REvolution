module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam MAX_COUNT = 10'd999;

    wire is_max_count;
    reg  [9:0] next_q;

    assign is_max_count = (q == MAX_COUNT);

    // Combinational next-state logic
    always @(*) begin
        if (is_max_count)
            next_q = 10'd0;
        else
            next_q = q + 10'd1;
    end

    // Sequential logic: synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule