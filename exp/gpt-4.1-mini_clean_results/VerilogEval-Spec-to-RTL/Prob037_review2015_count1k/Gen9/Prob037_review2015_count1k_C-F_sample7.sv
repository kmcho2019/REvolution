module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    parameter MAX_COUNT = 10'd999;
    wire [9:0] next_q;

    // Explicit if-else in combinational logic for clarity and potential optimization
    assign next_q = (q == MAX_COUNT) ? 10'd0 : (q + 10'd1);

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule