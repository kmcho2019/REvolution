module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    wire [4:0] q_plus_one = {1'b0, q} + 5'd1; // 5-bit addition to detect overflow beyond 9 (10 decimal)

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (q_plus_one == 5'd10)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end

endmodule