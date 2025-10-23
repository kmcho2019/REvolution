module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10: binary 1010
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];

    // Next state logic with continuous assignment
    wire [3:0] next_q = reset ? 4'd1 :
                        (reached_ten ? 4'd1 : q + 1'b1);

    // State update on positive clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule