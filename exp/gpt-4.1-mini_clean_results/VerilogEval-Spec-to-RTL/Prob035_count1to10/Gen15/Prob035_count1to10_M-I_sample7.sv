module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic for next count value without reset logic
    always @(*) begin
        if (q == 4'd10)
            next_q = 4'd1;            // Wrap from 10 to 1
        else
            next_q = q + 4'd1;        // Increment otherwise
    end

    // Sequential logic: synchronous reset and update count on rising edge
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;                // Reset to 1 synchronously
        else
            q <= next_q;
    end

endmodule