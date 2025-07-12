module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire [3:0] next_q;

    // Combinational logic for next state: wrap around to 0 after 9
    assign next_q = (q == 4'd9) ? 4'd0 : (q + 4'd1);

    // Sequential logic: update counter on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= next_q;
    end

endmodule