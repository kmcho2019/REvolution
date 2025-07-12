module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Detect decimal 10: binary 1010
    wire reached_ten = q[3] & ~q[2] & q[1] & ~q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // synchronous active-high reset to 1
        end else begin
            if (reached_ten)
                q <= 4'd1;
            else
                q <= q + 1'b1;
        end
    end

endmodule