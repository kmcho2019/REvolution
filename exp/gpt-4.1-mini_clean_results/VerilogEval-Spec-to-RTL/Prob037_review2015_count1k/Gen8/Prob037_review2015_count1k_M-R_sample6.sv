module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    reg [9:0] next_q;

    // Combinational block to determine next counter value
    always @(*) begin
        if (q == MAX_COUNT)
            next_q = 10'd0;
        else
            next_q = q + 10'd1;
    end

    // Sequential block to update counter with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule