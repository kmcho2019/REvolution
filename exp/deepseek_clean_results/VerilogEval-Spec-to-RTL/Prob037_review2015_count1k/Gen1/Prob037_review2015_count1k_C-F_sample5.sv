module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q[9:3] == 7'b1111100) & (q[2:0] == 3'b111);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        if (terminal_count) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule