module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam MAX_COUNT = 10'd999;

    wire max_count_reached = (q == MAX_COUNT);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (max_count_reached) begin
            q <= 10'd0;
        end else begin
            q <= q + 10'd1;
        end
    end

endmodule