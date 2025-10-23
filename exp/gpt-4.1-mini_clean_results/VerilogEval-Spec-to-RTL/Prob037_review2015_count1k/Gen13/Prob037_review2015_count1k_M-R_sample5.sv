module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    reg [9:0] next_q;
    wire is_max_count;

    assign is_max_count = (q == MAX_COUNT);

    always @(*) begin
        if (is_max_count)
            next_q = 10'd0;
        else
            next_q = q + 10'd1;
    end

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule