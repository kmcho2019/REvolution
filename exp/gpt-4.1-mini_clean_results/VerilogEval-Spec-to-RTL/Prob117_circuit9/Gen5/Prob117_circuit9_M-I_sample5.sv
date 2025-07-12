module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    localparam CONST_FOUR = 3'd4;
    localparam MAX_COUNT = 3'd6;

    always @(posedge clk) begin
        if (a) begin
            if (q != CONST_FOUR)
                q <= CONST_FOUR;
            // else hold q at 4 to reduce toggling
        end else begin
            if (q == MAX_COUNT)
                q <= 3'd0;
            else
                q <= q + 3'd1;
        end
    end

endmodule