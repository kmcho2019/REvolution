module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    wire [3:0] next_q;

    // Compute next state combinationally
    assign next_q = (q == 4'd9) ? 4'd0 : (q + 4'd1);

    // Sequential logic: update on clock edge, synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= next_q;
    end

endmodule