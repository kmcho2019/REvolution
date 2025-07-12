module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] high_count;  // counts 0 to 15
    reg [5:0] low_count;   // counts 0 to 63

    always @(posedge clk) begin
        if (reset) begin
            high_count <= 4'd0;
            low_count  <= 6'd0;
            q <= 10'd0;
        end else begin
            if (high_count == 4'd15 && low_count == 6'd39) begin
                high_count <= 4'd0;
                low_count  <= 6'd0;
                q <= 10'd0;
            end else begin
                if (low_count == 6'd63) begin
                    low_count <= 6'd0;
                    high_count <= high_count + 4'd1;
                end else begin
                    low_count <= low_count + 6'd1;
                end
                q <= {high_count, low_count};
            end
        end
    end

endmodule