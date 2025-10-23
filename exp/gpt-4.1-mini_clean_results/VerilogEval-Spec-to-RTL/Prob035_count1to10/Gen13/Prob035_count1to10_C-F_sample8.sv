module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10 (binary 1010) using bitwise logic for minimal combinational overhead
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];
    reg [3:0] next_q;

    // Combinational next-state logic: independent of reset which is synchronous
    always @(*) begin
        if (reached_ten)
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