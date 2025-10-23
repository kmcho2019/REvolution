module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

// Lower digit counter: counts 0-9
reg [3:0] lower_digit;

// Upper digit counter: counts 0-99
reg [6:0] upper_digit;

always @(posedge clk) begin
    if (reset) begin
        lower_digit <= 4'd0;
        upper_digit <= 7'd0;
        q <= 10'd0;
    end else begin
        if (lower_digit == 4'd9) begin
            lower_digit <= 4'd0;
            if (upper_digit == 7'd99) begin
                upper_digit <= 7'd0;
            end else begin
                upper_digit <= upper_digit + 7'd1;
            end
        end else begin
            lower_digit <= lower_digit + 4'd1;
        end
        // Combine upper and lower digits to form count: count = upper_digit * 10 + lower_digit
        q <= upper_digit * 10 + lower_digit;
    end
end

endmodule