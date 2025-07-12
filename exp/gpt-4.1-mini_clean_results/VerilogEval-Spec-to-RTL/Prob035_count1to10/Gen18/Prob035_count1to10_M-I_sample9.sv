module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Use equality comparison for decimal 10 detection (simpler comparator)
    wire reached_ten = (q == 4'd10);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;          // synchronous reset to 1
        else if (reached_ten)
            q <= 4'd1;          // wrap to 1 after 10
        else
            q <= q + 1'b1;      // increment otherwise
    end

endmodule