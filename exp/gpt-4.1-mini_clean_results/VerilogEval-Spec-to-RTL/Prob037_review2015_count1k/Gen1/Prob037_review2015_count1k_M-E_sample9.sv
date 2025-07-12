module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);
    reg [3:0] low_digit;   // counts 0 to 9
    reg [6:0] high_digit;  // counts 0 to 99 (7 bits to cover 0-99)

    always @(posedge clk) begin
        if (reset) begin
            low_digit <= 4'd0;
            high_digit <= 7'd0;
            q <= 10'd0;
        end else begin
            if (low_digit == 4'd9) begin
                low_digit <= 4'd0;
                if (high_digit == 7'd99) begin
                    high_digit <= 7'd0;
                end else begin
                    high_digit <= high_digit + 7'd1;
                end
            end else begin
                low_digit <= low_digit + 4'd1;
            end
            q <= high_digit * 10 + low_digit;
        end
    end
endmodule