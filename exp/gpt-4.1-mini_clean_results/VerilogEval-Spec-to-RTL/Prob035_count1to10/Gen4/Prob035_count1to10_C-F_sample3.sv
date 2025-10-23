module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational block to determine next count value using a simple ternary operator
    always @(*) begin
        next_q = (q == 4'd10) ? 4'd1 : q + 4'd1;
    end

    // Sequential block to update the count on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule