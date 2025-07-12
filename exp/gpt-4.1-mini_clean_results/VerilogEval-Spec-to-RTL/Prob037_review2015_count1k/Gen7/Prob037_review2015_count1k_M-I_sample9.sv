module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for terminal count
    localparam MAX_COUNT = 10'd999;

    wire upper_bits_match;
    wire lower_bits_match;
    wire is_max_count;

    // Upper 3 bits of 999 = 7 (3'b111)
    assign upper_bits_match = (q[9:7] == 3'b111);
    // Lower 7 bits of 999 = 103 (7'b1100111)
    assign lower_bits_match = (q[6:0] == 7'b1100111);

    assign is_max_count = upper_bits_match & lower_bits_match;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            if (is_max_count) begin
                q <= 10'd0;
            end else begin
                q <= q + 10'd1;
            end
        end
    end

endmodule