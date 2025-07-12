module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;
        end else begin
            // When q == 10 (4'b1010), reset to 1, else increment
            q <= (q == 4'd10) ? 4'd1 : q + 1'b1;
        end
    end

endmodule