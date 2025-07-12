module TopModule (
    input clk,
    input rst_n,  // Active low asynchronous reset for initialization and stable start state
    input a,
    output reg [2:0] q
);

    localparam MODULO = 7;
    localparam CONST_FOUR = 3'd4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 3'd0;
        else if (a)
            q <= CONST_FOUR;
        else if (q == MODULO - 1)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end

endmodule