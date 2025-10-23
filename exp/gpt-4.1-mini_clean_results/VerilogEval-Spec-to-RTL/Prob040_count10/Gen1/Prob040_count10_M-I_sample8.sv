module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Combinational next state logic to optimize comparator
    wire rollover;
    // Detect if q == 9 (binary 1001)
    assign rollover = (q[3] & ~q[2] & ~q[1] & q[0]);

    wire [3:0] q_next;
    assign q_next = rollover ? 4'd0 : (q + 4'd1);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else begin
            q <= q_next;
        end
    end

endmodule