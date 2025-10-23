module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    // Detect when counter reaches decimal 10 (1010b)
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];

    reg [3:0] next_q;

    always @(*) begin
        if (reached_ten)
            next_q = 4'd1;
        else
            next_q = q + 4'd1;
    end

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule