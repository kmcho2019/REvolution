module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] next_q;

    always @(*) begin
        if (q == 10'd999)
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