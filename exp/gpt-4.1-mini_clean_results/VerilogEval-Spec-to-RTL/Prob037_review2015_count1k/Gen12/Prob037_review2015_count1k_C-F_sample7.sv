module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;
    reg [9:0] next_q;

    // Next state combinational logic
    always @(*) begin
        if (reset)
            next_q = 10'd0;
        else if (q == MAX_COUNT)
            next_q = 10'd0;
        else
            next_q = q + 10'd1;
    end

    // Sequential state update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule