module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational next-state logic: detect decimal 10 using equality check
    always @(*) begin
        if (q == 4'd10)
            next_q = 4'd1;      // Wrap back to 1 after 10
        else
            next_q = q + 1'b1;  // Increment otherwise
    end

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;          // Synchronous active-high reset sets count to 1
        else
            q <= next_q;        // Update state with next count
    end

endmodule