module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digit0, digit1, digit2, digit3;

    // Enable signals for incrementing digits 1, 2, and 3
    assign ena[0] = (digit0 == 4'd9);
    assign ena[1] = ena[0] && (digit1 == 4'd9);
    assign ena[2] = ena[1] && (digit2 == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Increment ones digit every clock cycle
            if (digit0 == 4'd9) 
                digit0 <= 4'd0;
            else
                digit0 <= digit0 + 4'd1;

            // Increment tens digit when enabled
            if (ena[0]) begin
                if (digit1 == 4'd9) 
                    digit1 <= 4'd0;
                else
                    digit1 <= digit1 + 4'd1;
            end

            // Increment hundreds digit when enabled
            if (ena[1]) begin
                if (digit2 == 4'd9)
                    digit2 <= 4'd0;
                else
                    digit2 <= digit2 + 4'd1;
            end

            // Increment thousands digit when enabled
            if (ena[2]) begin
                if (digit3 == 4'd9)
                    digit3 <= 4'd0;
                else
                    digit3 <= digit3 + 4'd1;
            end
        end
    end

    assign q = {digit3, digit2, digit1, digit0};

endmodule