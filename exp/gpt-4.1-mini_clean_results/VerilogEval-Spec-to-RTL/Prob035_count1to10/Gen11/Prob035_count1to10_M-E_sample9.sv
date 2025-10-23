module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;
        end else begin
            // If q >= 10 (decimal 10), reset to 1
            // 10 decimal = 1010 binary
            // Condition: q[3] & (q[2] | q[1])
            if (q[3] & (q[2] | q[1])) 
                q <= 4'd1;
            else
                q <= q + 1'b1;
        end
    end

endmodule