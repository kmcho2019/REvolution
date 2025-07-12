module TopModule(
    input  wire       clk,
    input  wire       reset,
    output reg [2:0]  ena,
    output reg [15:0] q
);

    // Extract digits for clarity (not necessary but for readability)
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Internal registers to hold digits separately for easier manipulation
    reg [3:0] digit0, digit1, digit2, digit3;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: clear all digits and disables
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Default: disable all enables
            ena <= 3'b000;

            // Increment ones digit (digit0)
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;

                // Enable increment of tens digit (digit1)
                ena[0] <= 1'b1;
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;

                    // Enable increment of hundreds digit (digit2)
                    ena[1] <= 1'b1;
                    if (digit2 == 4'd9) begin
                        digit2 <= 4'd0;

                        // Enable increment of thousands digit (digit3)
                        ena[2] <= 1'b1;
                        if (digit3 == 4'd9) begin
                            digit3 <= 4'd0;
                        end else begin
                            digit3 <= digit3 + 4'd1;
                        end
                    end else begin
                        digit2 <= digit2 + 4'd1;
                    end
                end else begin
                    digit1 <= digit1 + 4'd1;
                end
            end else begin
                digit0 <= digit0 + 4'd1;
            end
        end
    end

    // Combine digits back into q
    always @(*) begin
        q = {digit3, digit2, digit1, digit0};
    end

endmodule