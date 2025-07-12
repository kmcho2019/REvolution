module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    // Parameter for terminal count
    localparam MAX_COUNT = 10'd999;

    // Upper 3 bits of 999 decimal is 7 (3'b111)
    // Lower 7 bits of 999 decimal is 103 (7'b1100111)
    wire upper_match = (q[9:7] == 3'b111);
    wire lower_match = (q[6:0] == 7'b1100111);
    wire is_max_count = upper_match & lower_match;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (is_max_count) begin
            q <= 10'd0;
        end else begin
            q <= q + 10'd1;
        end
    end

endmodule