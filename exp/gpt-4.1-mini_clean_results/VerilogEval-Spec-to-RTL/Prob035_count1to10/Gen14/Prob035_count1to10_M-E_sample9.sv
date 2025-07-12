module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;               // synchronous reset to 1
        end else begin
            if (q == 4'd10)
                q <= 4'd1;           // wrap to 1 after 10
            else
                q <= q + 1'b1;       // increment count
        end
    end

endmodule