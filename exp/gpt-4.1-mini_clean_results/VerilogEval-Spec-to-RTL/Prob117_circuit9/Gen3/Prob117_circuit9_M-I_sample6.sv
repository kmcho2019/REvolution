module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (a) begin
            if (q != 3'd4)
                q <= 3'd4;
        end else begin
            // Calculate next incremented value modulo 7
            wire [2:0] next_q = (q == 3'd6) ? 3'd0 : q + 1'b1;
            if (q != next_q)
                q <= next_q;
        end
    end
endmodule