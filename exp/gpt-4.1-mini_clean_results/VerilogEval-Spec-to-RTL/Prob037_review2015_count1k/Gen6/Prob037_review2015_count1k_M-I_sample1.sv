module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Constant for max count value
    localparam MAX_COUNT = 10'd999;

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else if (q == MAX_COUNT)
            q <= 10'd0;
        else
            q <= q + 10'd1;
    end

endmodule