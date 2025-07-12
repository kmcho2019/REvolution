module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic for next state
    always @(*) begin
        if ((q[3] & ~q[2] & q[1] & ~q[0]) == 1'b1)
            next_q = 4'd1;
        else
            next_q = q + 1'b1;
    end

    // Sequential logic for q update
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule