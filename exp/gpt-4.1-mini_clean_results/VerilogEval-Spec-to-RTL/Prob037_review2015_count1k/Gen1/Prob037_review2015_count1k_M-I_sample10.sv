module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            // Wrap counter after 999 to 0 using addition check
            q <= (q == 10'd999) ? 10'd0 : q + 10'd1;
        end
    end

endmodule