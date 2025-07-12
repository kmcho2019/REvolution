module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q[9:5] == 5'b11111) & (q[2:0] == 3'b111) & (q[4:3] == 2'b00);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else if (terminal_count) begin
        q <= 10'b0;
    end
    else begin
        q <= q + 1'b1;
    end
end

endmodule