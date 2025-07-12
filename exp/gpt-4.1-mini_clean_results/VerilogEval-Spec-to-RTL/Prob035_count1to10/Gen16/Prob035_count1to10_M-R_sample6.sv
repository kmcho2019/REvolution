module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire reached_ten = (q == 4'd10);
    wire [3:0] next_q;

    // Next state logic with continuous assignment
    assign next_q = reset ? 4'd1 : (reached_ten ? 4'd1 : q + 1'b1);

    // Sequential logic: update q on posedge clk with synchronous reset
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule