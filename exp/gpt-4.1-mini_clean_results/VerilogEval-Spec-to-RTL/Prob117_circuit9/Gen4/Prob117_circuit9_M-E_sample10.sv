module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);
    wire [3:0] q_next; // 4-bit to detect overflow at 7

    // Increment q by 1, extended to 4 bits to check for modulo 7 wrap
    assign q_next = {1'b0, q} + 4'd1;

    always @(posedge clk) begin
        if (a)
            q <= 3'd4;                // load 4 when a is high
        else if (q_next == 4'd7)
            q <= 3'd0;                // wrap to zero if q == 6 before increment
        else
            q <= q_next[2:0];        // increment q otherwise
    end
endmodule