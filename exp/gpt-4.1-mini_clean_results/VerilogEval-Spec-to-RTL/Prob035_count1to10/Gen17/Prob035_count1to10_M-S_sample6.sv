module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;          // synchronous reset to 1
        else if (q == 4'd10)
            q <= 4'd1;          // wrap after 10
        else
            q <= q + 1'b1;      // increment otherwise
    end

endmodule