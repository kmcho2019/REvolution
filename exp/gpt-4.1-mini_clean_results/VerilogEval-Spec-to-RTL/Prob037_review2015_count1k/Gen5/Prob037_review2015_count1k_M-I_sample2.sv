module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    wire terminal_count = (q == 10'd999);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (terminal_count) begin
            q <= 10'd0;
        end else begin
            q <= q + 10'd1;
        end
    end

endmodule