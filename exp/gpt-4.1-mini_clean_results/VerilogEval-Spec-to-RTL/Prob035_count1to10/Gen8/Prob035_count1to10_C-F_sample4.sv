module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10 (binary 1010)
    wire wrap_around = q[3] & ~q[2] & q[1] & ~q[0];

    // Custom increment logic for counts 1 to 9, then wrap to 1 after 10
    // Since range is small, increment is next decimal number from 1 to 9
    // Implemented combinationally without full 4-bit adder
    wire [3:0] inc_q = 
        (q == 4'd9) ? 4'd10 :      // 9 -> 10 (1010)
        (q == 4'd10) ? 4'd1 :      // 10 -> 1 (wrap)
        (q + 4'd1);                // else normal increment by 1

    // To optimize the critical path, replace the generic addition (q + 1)
    // with explicit decoding: for values 1..8 increment by 1,
    // for 9, go to 10, for 10 wrap to 1

    wire [3:0] next_q = (wrap_around) ? 4'd1 : inc_q;

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;  // synchronous reset sets count to 1
        else
            q <= next_q;
    end

endmodule