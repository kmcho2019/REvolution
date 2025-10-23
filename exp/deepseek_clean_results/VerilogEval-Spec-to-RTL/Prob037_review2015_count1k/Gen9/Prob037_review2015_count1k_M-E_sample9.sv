module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [5:0] lower_counter;  // 0-63
reg [3:0] upper_counter; // 0-15
wire lower_carry = (lower_counter == 6'd63);
wire terminal_count = (upper_counter == 4'd15) && (lower_counter == 6'd39); // 15*64 + 39 = 999

always @(posedge clk) begin
    if (reset || terminal_count) begin
        lower_counter <= 6'd0;
        upper_counter <= 4'd0;
    end else begin
        if (lower_carry) begin
            lower_counter <= 6'd0;
            upper_counter <= upper_counter + 1'b1;
        end else begin
            lower_counter <= lower_counter + 1'b1;
        end
    end
end

// Combine counters to form final output
always @(*) begin
    q = {upper_counter, lower_counter};
    // Adjust for the special case when we need to stop at 999
    if (upper_counter > 4'd15) q = 10'd999;
    else if (upper_counter == 4'd15 && lower_counter > 6'd39) q = 10'd999;
end

endmodule