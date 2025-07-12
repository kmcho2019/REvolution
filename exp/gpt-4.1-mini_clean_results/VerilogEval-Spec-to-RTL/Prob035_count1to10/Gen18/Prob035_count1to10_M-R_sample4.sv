module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10 using assign outside always block for combinational logic
    wire reached_ten = (q == 4'd10);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;          // Synchronous reset to 1
        else if (reached_ten)
            q <= 4'd1;          // Wrap to 1 after 10
        else
            q <= q + 1'b1;      // Increment otherwise
    end

endmodule