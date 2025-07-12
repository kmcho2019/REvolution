module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic for next count value
    always @(*) begin
        if (reset)
            next_q = 4'd1;                      // Synchronous reset to 1
        else if ((q[3] & ~q[2] & q[1] & ~q[0]) == 1'b1)
            next_q = 4'd1;                      // Wrap from 10 to 1
        else
            next_q = q + 1'b1;                  // Increment otherwise
    end

    // Sequential logic: update count on rising edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule