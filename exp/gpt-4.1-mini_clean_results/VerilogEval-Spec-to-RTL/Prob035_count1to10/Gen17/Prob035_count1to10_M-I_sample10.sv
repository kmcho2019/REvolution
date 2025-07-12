module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10 using equality check
    wire reached_ten = (q == 4'd10);

    // Next state logic with simpler comparator
    wire [3:0] next_q = reset ? 4'd1 :
                        (reached_ten ? 4'd1 : q + 1'b1);

    // State update on positive clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule