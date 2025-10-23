module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

localparam TERMINAL_COUNT = 4'd10;
localparam RESET_VALUE = 4'd1;

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VALUE;
    end else begin
        if (q == TERMINAL_COUNT)
            q <= RESET_VALUE;
        else
            q <= q + 4'd1;
    end
end

endmodule