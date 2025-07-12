module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    // Detect decimal 10 (binary 1010)
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];

    reg [3:0] next_q;

    // Combinational logic for next count value including synchronous reset
    always @(*) begin
        if (reset)
            next_q = 4'd1;           // synchronous reset to 1
        else if (reached_ten)
            next_q = 4'd1;           // wrap to 1 after 10
        else
            next_q = q + 1'b1;       // increment otherwise
    end

    // Sequential logic: update count on rising clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule