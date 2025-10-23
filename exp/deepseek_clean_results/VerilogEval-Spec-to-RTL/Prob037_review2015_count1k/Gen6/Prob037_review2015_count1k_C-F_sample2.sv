module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg terminal_count;

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
        terminal_count <= 1'b0;
    end
    else begin
        terminal_count <= (q == 10'd999);
        if (terminal_count) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule