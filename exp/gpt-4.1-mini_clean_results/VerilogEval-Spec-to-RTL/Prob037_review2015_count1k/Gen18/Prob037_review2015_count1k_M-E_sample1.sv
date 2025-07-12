module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    // Separate counters for hundreds (0-9) and remainder (0-99)
    reg [3:0] high_count;   // 0 to 9
    reg [5:0] low_count;    // 0 to 99

    // Constants for max counts
    localparam LOW_MAX  = 6'd99;
    localparam HIGH_MAX = 4'd9;

    always @(posedge clk) begin
        if (reset) begin
            high_count <= 4'd0;
            low_count  <= 6'd0;
        end else begin
            if (low_count == LOW_MAX) begin
                low_count <= 6'd0;
                if (high_count == HIGH_MAX) begin
                    high_count <= 4'd0;
                end else begin
                    high_count <= high_count + 4'd1;
                end
            end else begin
                low_count <= low_count + 6'd1;
            end
        end
    end

    // Combine high and low counters into output
    always @(*) begin
        q = {high_count, low_count};
    end

endmodule