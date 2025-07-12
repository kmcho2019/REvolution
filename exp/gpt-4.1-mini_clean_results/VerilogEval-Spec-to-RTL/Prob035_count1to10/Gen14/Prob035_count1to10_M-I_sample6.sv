module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Use a simpler equality comparator for decimal 10
    wire reached_ten = (q == 4'd10);

    // Combinational next-state logic
    always @(*) begin
        if (reached_ten)
            next_q = 4'd1;      // Wrap to 1 after 10
        else
            next_q = q + 1'b1;  // Increment otherwise
    end

    // Synchronous reset and sequential update
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;          // Synchronous active-high reset to 1
        else
            q <= next_q;        // Update count
    end

endmodule