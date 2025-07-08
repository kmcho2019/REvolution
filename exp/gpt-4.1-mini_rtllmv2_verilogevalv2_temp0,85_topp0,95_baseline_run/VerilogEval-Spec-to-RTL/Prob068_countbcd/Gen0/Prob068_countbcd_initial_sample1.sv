module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal registers for each BCD digit
    reg [3:0] digit0, digit1, digit2, digit3;

    // Wires to detect rollovers
    wire digit0_rollover, digit1_rollover, digit2_rollover;

    always @(posedge clk) begin
        if (reset) begin
            // Reset all digits and disables
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Increment ones digit
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
            end else begin
                digit0 <= digit0 + 1'b1;
            end

            // Generate enable signals and increment upper digits
            // digit1 enable when digit0 rolls over
            if (digit0 == 4'd9) begin
                ena[0] <= 1'b1;
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                end else begin
                    digit1 <= digit1 + 1'b1;
                end
            end else begin
                ena[0] <= 1'b0;
            end

            // digit2 enable when digit1 rolls over
            if (ena[0] && (digit1 == 4'd9)) begin
                ena[1] <= 1'b1;
                if (digit2 == 4'd9) begin
                    digit2 <= 4'd0;
                end else begin
                    digit2 <= digit2 + 1'b1;
                end
            end else begin
                ena[1] <= 1'b0;
            end

            // digit3 enable when digit2 rolls over
            if (ena[1] && (digit2 == 4'd9)) begin
                ena[2] <= 1'b1;
                if (digit3 == 4'd9) begin
                    digit3 <= 4'd0;
                end else begin
                    digit3 <= digit3 + 1'b1;
                end
            end else begin
                ena[2] <= 1'b0;
            end
        end
    end

    // Combine digits into output q
    always @(*) begin
        q = {digit3, digit2, digit1, digit0};
    end

endmodule