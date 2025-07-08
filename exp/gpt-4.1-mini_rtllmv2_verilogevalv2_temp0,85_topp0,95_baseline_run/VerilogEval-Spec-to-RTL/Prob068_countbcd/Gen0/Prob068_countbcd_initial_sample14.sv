module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    wire ones_rollover;
    wire tens_rollover;
    wire hundreds_rollover;

    // Extract digits for clarity
    wire [3:0] ones = q[3:0];
    wire [3:0] tens = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            // increment ones digit
            if (ones == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= ones + 1;
            end

            // ena[0] indicates if tens should increment (when ones rolls over)
            ena[0] <= (ones == 4'd9);

            // increment tens digit if ena[0] is asserted
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    q[7:4] <= 4'd0;
                end else begin
                    q[7:4] <= tens + 1;
                end
            end

            // ena[1] indicates if hundreds should increment (when tens rolls over)
            ena[1] <= ena[0] && (tens == 4'd9);

            // increment hundreds digit if ena[1] is asserted
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    q[11:8] <= 4'd0;
                end else begin
                    q[11:8] <= hundreds + 1;
                end
            end

            // ena[2] indicates if thousands should increment (when hundreds rolls over)
            ena[2] <= ena[1] && (hundreds == 4'd9);

            // increment thousands digit if ena[2] is asserted
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= thousands + 1;
                end
            end
        end
    end

endmodule