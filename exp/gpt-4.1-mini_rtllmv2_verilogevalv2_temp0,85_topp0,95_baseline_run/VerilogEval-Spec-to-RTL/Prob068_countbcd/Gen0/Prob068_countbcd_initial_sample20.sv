module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    wire ones_rollover;
    wire tens_rollover;
    wire hundreds_rollover;

    // Extract digits
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Check if digit is 9
    wire ones_is_9 = (ones == 4'd9);
    wire tens_is_9 = (tens == 4'd9);
    wire hundreds_is_9 = (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Increment ones digit
            if (ones_is_9) begin
                // Rollover ones digit to 0 and enable increment tens
                q[3:0] <= 4'd0;
                ena[0] <= 1'b1;
            end else begin
                q[3:0] <= ones + 1'b1;
                ena[0] <= 1'b0;
            end

            // Increment tens digit if ena[0] is set
            if (ena[0]) begin
                if (tens_is_9) begin
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1;
                end else begin
                    q[7:4] <= tens + 1'b1;
                    ena[1] <= 1'b0;
                end
            end else begin
                // If tens digit not incremented this cycle, clear ena[1]
                ena[1] <= 1'b0;
            end

            // Increment hundreds digit if ena[1] is set
            if (ena[1]) begin
                if (hundreds_is_9) begin
                    q[11:8] <= 4'd0;
                    ena[2] <= 1'b1;
                end else begin
                    q[11:8] <= hundreds + 1'b1;
                    ena[2] <= 1'b0;
                end
            end else begin
                // If hundreds digit not incremented, clear ena[2]
                ena[2] <= 1'b0;
            end

            // Increment thousands digit if ena[2] is set
            if (ena[2]) begin
                if (thousands == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= thousands + 1'b1;
            end
            // If ena[2] not set, thousands digit remains the same
        end
    end

endmodule