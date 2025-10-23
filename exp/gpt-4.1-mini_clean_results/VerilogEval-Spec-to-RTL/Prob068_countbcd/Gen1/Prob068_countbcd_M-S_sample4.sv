module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0] = ones, digits[3] = thousands
    reg carry1, carry2, carry3;

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
            ena <= 3'b000;
            q <= 16'd0;
        end else begin
            // Increment ones digit
            if (digits[0] == 4'd9) begin
                digits[0] <= 4'd0;
                carry1 <= 1'b1;
            end else begin
                digits[0] <= digits[0] + 4'd1;
                carry1 <= 1'b0;
            end

            // Increment tens digit if carry from ones
            if (carry1) begin
                if (digits[1] == 4'd9) begin
                    digits[1] <= 4'd0;
                    carry2 <= 1'b1;
                end else begin
                    digits[1] <= digits[1] + 4'd1;
                    carry2 <= 1'b0;
                end
            end else begin
                carry2 <= 1'b0;
                digits[1] <= digits[1];
            end

            // Increment hundreds digit if carry from tens
            if (carry2) begin
                if (digits[2] == 4'd9) begin
                    digits[2] <= 4'd0;
                    carry3 <= 1'b1;
                end else begin
                    digits[2] <= digits[2] + 4'd1;
                    carry3 <= 1'b0;
                end
            end else begin
                carry3 <= 1'b0;
                digits[2] <= digits[2];
            end

            // Increment thousands digit if carry from hundreds
            if (carry3) begin
                if (digits[3] == 4'd9)
                    digits[3] <= 4'd0;
                else
                    digits[3] <= digits[3] + 4'd1;
            end else begin
                digits[3] <= digits[3];
            end

            // ena signals correspond to carries from ones, tens, and hundreds digits
            ena <= {carry3, carry2, carry1};

            // Output concatenated digits
            q <= {digits[3], digits[2], digits[1], digits[0]};
        end
    end

endmodule