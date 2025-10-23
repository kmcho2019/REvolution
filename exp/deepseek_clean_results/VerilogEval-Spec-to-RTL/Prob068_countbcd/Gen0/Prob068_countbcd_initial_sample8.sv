module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] bcd_digits [0:3];  // 4 digits: [0]=ones, [1]=tens, [2]=hundreds, [3]=thousands
    reg [2:0] ena_reg;

    // Assign outputs
    assign q = {bcd_digits[3], bcd_digits[2], bcd_digits[1], bcd_digits[0]};
    assign ena = ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset all digits to 0
            bcd_digits[0] <= 4'b0;
            bcd_digits[1] <= 4'b0;
            bcd_digits[2] <= 4'b0;
            bcd_digits[3] <= 4'b0;
            ena_reg <= 3'b0;
        end else begin
            // Default enable signals to 0
            ena_reg <= 3'b0;

            // Always increment ones digit
            if (bcd_digits[0] == 4'd9) begin
                bcd_digits[0] <= 4'd0;
                ena_reg[0] <= 1'b1;  // Enable tens digit
            end else begin
                bcd_digits[0] <= bcd_digits[0] + 4'd1;
            end

            // Handle tens digit
            if (ena_reg[0]) begin
                if (bcd_digits[1] == 4'd9) begin
                    bcd_digits[1] <= 4'd0;
                    ena_reg[1] <= 1'b1;  // Enable hundreds digit
                end else begin
                    bcd_digits[1] <= bcd_digits[1] + 4'd1;
                end
            end

            // Handle hundreds digit
            if (ena_reg[1]) begin
                if (bcd_digits[2] == 4'd9) begin
                    bcd_digits[2] <= 4'd0;
                    ena_reg[2] <= 1'b1;  // Enable thousands digit
                end else begin
                    bcd_digits[2] <= bcd_digits[2] + 4'd1;
                end
            end

            // Handle thousands digit
            if (ena_reg[2]) begin
                if (bcd_digits[3] == 4'd9) begin
                    bcd_digits[3] <= 4'd0;
                end else begin
                    bcd_digits[3] <= bcd_digits[3] + 4'd1;
                end
            end
        end
    end

endmodule