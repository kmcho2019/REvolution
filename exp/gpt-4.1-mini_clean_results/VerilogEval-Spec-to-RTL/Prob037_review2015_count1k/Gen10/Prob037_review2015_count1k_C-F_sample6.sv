module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Parameter for terminal count
    localparam MAX_COUNT = 10'd999;

    // Split terminal count check into upper and lower parts
    wire upper_match = (q[9:7] == MAX_COUNT[9:7]); // Should be 3'b111
    wire lower_match = (q[6:0] == MAX_COUNT[6:0]); // Should be 7'b1100111
    wire is_max_count = upper_match & lower_match;

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