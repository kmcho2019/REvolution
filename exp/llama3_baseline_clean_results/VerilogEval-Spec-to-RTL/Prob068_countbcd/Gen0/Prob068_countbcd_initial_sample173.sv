module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 16'd0;
    end else begin
        // Increment the ones digit
        if (q[3:0] == 4'd9) begin
            q[3:0] <= 4'd0;
            ena[0] <= 1'b1;  // Enable the tens digit
        end else begin
            q[3:0] <= q[3:0] + 1;
            ena[0] <= 1'b0;
        end

        // Increment the tens digit
        if (ena[0] && q[7:4] == 4'd9) begin
            q[7:4] <= 4'd0;
            ena[1] <= 1'b1;  // Enable the hundreds digit
        end else if (ena[0]) begin
            q[7:4] <= q[7:4] + 1;
            ena[1] <= 1'b0;
        end else begin
            ena[1] <= 1'b0;
        end

        // Increment the hundreds digit
        if (ena[1] && q[11:8] == 4'd9) begin
            q[11:8] <= 4'd0;
            ena[2] <= 1'b1;  // Enable the thousands digit
        end else if (ena[1]) begin
            q[11:8] <= q[11:8] + 1;
            ena[2] <= 1'b0;
        end else begin
            ena[2] <= 1'b0;
        end

        // Increment the thousands digit
        if (ena[2] && q[15:12] == 4'd9) begin
            q[15:12] <= 4'd0;
        end else if (ena[2]) begin
            q[15:12] <= q[15:12] + 1;
        end
    end
end

endmodule