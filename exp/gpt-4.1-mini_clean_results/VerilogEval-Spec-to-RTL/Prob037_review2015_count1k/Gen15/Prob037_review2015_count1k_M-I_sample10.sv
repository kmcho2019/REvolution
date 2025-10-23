module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam MAX_COUNT = 10'd999;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (q == MAX_COUNT) begin
            q <= 10'd0;
        end else begin
            q <= q + 1;
        end
    end

endmodule