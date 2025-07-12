module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    localparam MODULO = 7;
    localparam CONST_FOUR = 3'd4;

    always @(posedge clk) begin
        if (a) begin
            // Assign q = 4 only if not already 4 to reduce toggling
            if (q != CONST_FOUR)
                q <= CONST_FOUR;
            else
                q <= q;
        end
        else begin
            // Modulo 7 increment counter
            q <= (q == (MODULO - 1)) ? 3'd0 : q + 3'd1;
        end
    end

endmodule