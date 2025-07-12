module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MODULO = 10'd1000;

    wire [10:0] sum = q + 10'd1; // 11-bit to detect overflow beyond 999

    wire wrap = (sum >= MODULO);

    wire [9:0] next_q = wrap ? (sum - MODULO) : sum[9:0];

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= next_q;
    end

endmodule