module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    reg [3:0] next_q;
    wire count_is_10;

    // Detect count == 10 (binary 1010) with minimal logic
    assign count_is_10 = q[3] & ~q[2] & q[1] & ~q[0];

    // Combinational logic to determine next count value with enable gating
    always @(*) begin
        if (count_is_10)
            next_q = 4'd1;
        else
            next_q = q + 1'b1;
    end

    // Sequential logic: synchronous reset and update count
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule