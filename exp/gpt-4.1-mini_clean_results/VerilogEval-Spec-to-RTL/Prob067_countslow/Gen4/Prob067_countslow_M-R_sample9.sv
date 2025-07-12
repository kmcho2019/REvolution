module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    wire [3:0] q_next;

    // Combinational next-state logic using assign and ternary operator
    assign q_next = (q == 4'd9) ? 4'd0 : (q + 4'd1);

    // Sequential logic with synchronous reset and clock enable
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (slowena)
            q <= q_next;
    end

endmodule