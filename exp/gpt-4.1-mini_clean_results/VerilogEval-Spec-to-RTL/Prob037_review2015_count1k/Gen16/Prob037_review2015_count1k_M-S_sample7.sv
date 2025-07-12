module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam [9:0] MAX_COUNT = 10'd999;

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else if (q == MAX_COUNT)
            q <= 10'd0;
        else
            q <= q + 10'd1;
    end

endmodule