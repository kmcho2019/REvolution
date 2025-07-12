module TopModule (
    input        clk,
    input        reset,
    output reg [9:0] q
);

    localparam [9:0] MAX_COUNT = 10'd999;
    wire [9:0] count_next;

    assign count_next = (q == MAX_COUNT) ? 10'd0 : q + 10'd1;

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= count_next;
    end

endmodule