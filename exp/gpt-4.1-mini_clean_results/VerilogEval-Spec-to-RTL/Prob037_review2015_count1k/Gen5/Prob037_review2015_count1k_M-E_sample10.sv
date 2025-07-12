module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else begin
            // Compute next value with wrap-around at 1000
            if (q + 1 >= 10'd1000)
                q <= (q + 1) - 10'd1000;
            else
                q <= q + 1;
        end
    end

endmodule