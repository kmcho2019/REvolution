module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract digits from q for easier manipulation
    wire [3:0] d0 = q[3:0];   // ones
    wire [3:0] d1 = q[7:4];   // tens
    wire [3:0] d2 = q[11:8];  // hundreds
    wire [3:0] d3 = q[15:12]; // thousands

    reg [3:0] digits [3:0]; // 4 digits: digits[0]=ones ... digits[3]=thousands

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
                ena[0] <= 1'b1; // Enable tens increment
            end else begin
                digits[0] <= digits[0] + 4'd1;
                ena[0] <= 1'b0;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (digits[1] == 4'd9) begin
                    digits[1] <= 4'd0;
                    ena[1] <= 1'b1; // Enable hundreds increment
                end else begin
                    digits[1] <= digits[1] + 4'd1;
                    ena[1] <= 1'b0;
                end
            end else begin
                ena[1] <= 1'b0;
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (digits[2] == 4'd9) begin
                    digits[2] <= 4'd0;
                    ena[2] <= 1'b1; // Enable thousands increment
                end else begin
                    digits[2] <= digits[2] + 4'd1;
                    ena[2] <= 1'b0;
                end
            end else begin
                ena[2] <= 1'b0;
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (digits[3] == 4'd9) begin
                    digits[3] <= 4'd0;
                    // no further enable
                end else begin
                    digits[3] <= digits[3] + 4'd1;
                end
            end

            // Update output q
            q <= {digits[3], digits[2], digits[1], digits[0]};
        end
    end

endmodule