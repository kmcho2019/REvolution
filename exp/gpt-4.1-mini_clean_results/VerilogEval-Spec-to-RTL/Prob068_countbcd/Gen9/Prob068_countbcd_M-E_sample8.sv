module TopModule (
    input         clk,
    input         reset,
    output reg [2:0] ena,
    output reg [15:0] q
);
    reg [15:0] bcd_next;

    always @(posedge clk) begin
        if (reset) begin
            q   <= 16'd0;
            ena <= 3'd0;
        end else begin
            // Increment the least significant digit (ones)
            bcd_next = q + 16'd1;

            // Correct each BCD digit if > 9, propagate carry
            // Check ones digit (bits 3:0)
            if (bcd_next[3:0] > 4'd9) begin
                bcd_next[3:0] = 4'd0;
                bcd_next[7:4] = bcd_next[7:4] + 4'd1;
            end

            // Check tens digit (bits 7:4)
            if (bcd_next[7:4] > 4'd9) begin
                bcd_next[7:4] = 4'd0;
                bcd_next[11:8] = bcd_next[11:8] + 4'd1;
            end

            // Check hundreds digit (bits 11:8)
            if (bcd_next[11:8] > 4'd9) begin
                bcd_next[11:8] = 4'd0;
                bcd_next[15:12] = bcd_next[15:12] + 4'd1;
            end

            // Check thousands digit (bits 15:12)
            // Roll over from 9 back to 0 without carry beyond thousands
            if (bcd_next[15:12] > 4'd9) begin
                bcd_next[15:12] = 4'd0;
            end

            q <= bcd_next;

            // Enable signals: next digit increments if current digit was 9 before increment
            ena[0] <= (q[3:0] == 4'd9);
            ena[1] <= (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
            ena[2] <= (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);
        end
    end

endmodule