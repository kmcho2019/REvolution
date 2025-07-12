module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    localparam MAX_COUNT = 4'd9;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else if (q == MAX_COUNT) begin
            q <= 4'd0;
        end else begin
            q <= q + 4'd1;
        end
    end

endmodule