module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Synchronous active-high reset
        q <= 16'd0;
        ena <= 3'd0;
    end else begin
        // Check the current state of the digits
        if (q[3:0] != 4'd9) begin
            // If the ones digit is not equal to 9, increment it
            q[3:0] <= q[3:0] + 4'd1;
            ena <= 3'd0;
        end else if (q[7:4] != 4'd9) begin
            // If the ones digit is equal to 9, reset it to 0 and increment the tens digit
            q[3:0] <= 4'd0;
            q[7:4] <= q[7:4] + 4'd1;
            ena[0] <= 1'd1;
            ena[1] <= 1'd0;
            ena[2] <= 1'd0;
        end else if (q[11:8] != 4'd9) begin
            // If the tens digit is equal to 9, reset it to 0 and increment the hundreds digit
            q[3:0] <= 4'd0;
            q[7:4] <= 4'd0;
            q[11:8] <= q[11:8] + 4'd1;
            ena[0] <= 1'd1;
            ena[1] <= 1'd1;
            ena[2] <= 1'd0;
        end else if (q[15:12] != 4'd9) begin
            // If the hundreds digit is equal to 9, reset it to 0 and increment the thousands digit
            q[3:0] <= 4'd0;
            q[7:4] <= 4'd0;
            q[11:8] <= 4'd0;
            q[15:12] <= q[15:12] + 4'd1;
            ena[0] <= 1'd1;
            ena[1] <= 1'd1;
            ena[2] <= 1'd1;
        end else begin
            // If the thousands digit is equal to 9, reset all digits to 0
            q <= 16'd0;
            ena <= 3'd0;
        end
    end
end

endmodule