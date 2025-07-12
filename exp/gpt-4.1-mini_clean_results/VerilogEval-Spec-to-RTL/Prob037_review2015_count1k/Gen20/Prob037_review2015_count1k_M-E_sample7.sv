module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] low_count;   // Counts 0..9
    reg [6:0] high_count;  // Counts 0..99 (max 7 bits needed)

    always @(posedge clk) begin
        if (reset) begin
            low_count <= 4'd0;
            high_count <= 7'd0;
            q <= 10'd0;
        end else begin
            if (low_count == 4'd9) begin
                low_count <= 4'd0;
                if (high_count == 7'd99) begin
                    high_count <= 7'd0;
                end else begin
                    high_count <= high_count + 7'd1;
                end
            end else begin
                low_count <= low_count + 4'd1;
            end
            q <= high_count * 10 + low_count;
        end
    end

endmodule