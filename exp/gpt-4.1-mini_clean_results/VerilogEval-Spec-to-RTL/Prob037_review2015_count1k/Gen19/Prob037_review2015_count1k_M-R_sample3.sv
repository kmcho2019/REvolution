module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam MAX_COUNT = 10'd999;

    wire at_max_count = (q == MAX_COUNT);
    wire [9:0] next_q = (reset || at_max_count) ? 10'd0 : q + 10'd1;

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule