module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    // Detect decimal 10: binary 1010
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];

    reg [3:0] next_q;

    // Combinational logic for next state
    always @(*) begin
        if (reached_ten)
            next_q = 4'd1;
        else
            next_q = q + 4'd1;
    end

    // Sequential logic: register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule