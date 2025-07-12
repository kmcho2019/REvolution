module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    localparam MODULO = 7;
    localparam CONST_FOUR = 3'd4;

    always @(posedge clk) begin
        if (a) begin
            if (q != CONST_FOUR)
                q <= CONST_FOUR;
            else
                q <= q;
        end else begin
            if (q == MODULO - 1)
                q <= 3'd0;
            else
                q <= q + 3'd1;
        end
    end

endmodule