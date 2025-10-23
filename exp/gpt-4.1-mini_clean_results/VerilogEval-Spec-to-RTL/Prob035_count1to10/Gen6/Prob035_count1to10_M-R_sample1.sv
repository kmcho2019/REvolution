module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire [3:0] next_q;

    // Combinational next state logic with continuous assignment
    assign next_q = (q == 4'd10) ? 4'd1 : q + 4'd1;

    // Synchronous state update with active high synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule