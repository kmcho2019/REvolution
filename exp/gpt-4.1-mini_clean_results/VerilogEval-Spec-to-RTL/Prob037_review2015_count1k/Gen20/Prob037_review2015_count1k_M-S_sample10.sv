module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam MAX_COUNT = 10'd999;
    reg [9:0] next_q;
    wire is_max_count;

    assign is_max_count = (q == MAX_COUNT);

    always @(*) begin
        if (reset) begin
            next_q = 10'd0;
        end else if (is_max_count) begin
            next_q = 10'd0;
        end else begin
            next_q = q + 10'd1;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule