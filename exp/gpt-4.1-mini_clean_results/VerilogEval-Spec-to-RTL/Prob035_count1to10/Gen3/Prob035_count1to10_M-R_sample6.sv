module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire [3:0] next_q;

    // Combinational logic to determine next count value
    assign next_q = (q == 4'd10) ? 4'd1 : q + 4'd1;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= next_q;
    end

endmodule