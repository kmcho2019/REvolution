module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam [9:0] MAX_COUNT = 10'd999;

    // Combinational next state calculation using a single equality comparator
    wire is_max_count = (q == MAX_COUNT);
    wire [9:0] next_q = is_max_count ? 10'd0 : (q + 10'd1);

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            q <= next_q;
        end
    end

endmodule