module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    localparam MAX_COUNT = 10'd999;

    wire [9:0] next_q;
    wire terminal_count = (q == MAX_COUNT);

    assign next_q = terminal_count ? 10'd0 : (q + 10'd1);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            q <= next_q;
        end
    end

endmodule