module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Counters for two decimal digits
    reg [6:0] low_digit;  // Counts 0 to 99 (7 bits)
    reg [3:0] high_digit; // Counts 0 to 9 (4 bits)

    always @(posedge clk) begin
        if (reset) begin
            low_digit <= 7'd0;
            high_digit <= 4'd0;
            q <= 10'd0;
        end else begin
            if (low_digit == 7'd99) begin
                low_digit <= 7'd0;
                if (high_digit == 4'd9) begin
                    high_digit <= 4'd0;
                    q <= 10'd0;
                end else begin
                    high_digit <= high_digit + 4'd1;
                    q <= (high_digit + 4'd1)*10'd100;
                end
            end else begin
                low_digit <= low_digit + 7'd1;
                q <= high_digit * 10'd100 + (low_digit + 7'd1);
            end
        end
    end

endmodule