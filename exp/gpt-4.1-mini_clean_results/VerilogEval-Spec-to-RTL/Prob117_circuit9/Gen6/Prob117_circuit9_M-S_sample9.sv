module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // q cycles through 4->5->6->0->1->2->3->4 (modulo 7 counting starting from 4)
        // Map q to 0-6 by (q + 3) mod 7, increment, then map back by subtracting 3 mod 7.
        // But simpler: if q == 6, next q = 0; else q + 1
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule