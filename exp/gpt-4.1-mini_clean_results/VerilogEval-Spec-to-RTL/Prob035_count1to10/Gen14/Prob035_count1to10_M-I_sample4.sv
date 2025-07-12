module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;                  // Synchronous reset to 1
        else if (q == 4'd10)
            q <= 4'd1;                  // Wrap from 10 to 1
        else
            q <= q + 4'd1;              // Increment otherwise
    end

endmodule