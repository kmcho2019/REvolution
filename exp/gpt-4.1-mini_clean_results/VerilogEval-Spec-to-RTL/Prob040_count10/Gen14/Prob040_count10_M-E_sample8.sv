module TopModule (
    input        clk,
    input        reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic to compute next count value
    always @(*) begin
        if (q == 4'd9)
            next_q = 4'd0;
        else
            next_q = q + 4'd1;
    end

    // Sequential logic to update count on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= next_q;
    end

endmodule