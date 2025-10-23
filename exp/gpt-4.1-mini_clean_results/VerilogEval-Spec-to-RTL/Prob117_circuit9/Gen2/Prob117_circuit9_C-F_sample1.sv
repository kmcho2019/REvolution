module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            if (q != 3'd4)
                q <= 3'd4;
            // else: no update to avoid redundant write
        end else begin
            // compute next value with wrap-around
            reg [2:0] next_q;
            next_q = (q == 3'd6) ? 3'd0 : (q + 3'd1);
            if (q != next_q)
                q <= next_q;
            // else: no update to avoid redundant write
        end
    end

endmodule