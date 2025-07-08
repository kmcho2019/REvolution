module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);
    // Extract each digit
    wire [3:0] digit0 = q[3:0];
    wire [3:0] digit1 = q[7:4];
    wire [3:0] digit2 = q[11:8];
    wire [3:0] digit3 = q[15:12];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'd0;
        end else begin
            // Default ena zero
            ena <= 3'd0;

            // Increment ones digit
            if (digit0 == 4'd9) begin
                // Ones digit rolls over
                q[3:0] <= 4'd0;

                // Increment tens digit and set ena[0]
                ena[0] <= 1'b1;
                if (digit1 == 4'd9) begin
                    // Tens digit rolls over
                    q[7:4] <= 4'd0;

                    // Increment hundreds digit and set ena[1]
                    ena[1] <= 1'b1;
                    if (digit2 == 4'd9) begin
                        // Hundreds digit rolls over
                        q[11:8] <= 4'd0;

                        // Increment thousands digit and set ena[2]
                        ena[2] <= 1'b1;
                        if (digit3 == 4'd9) begin
                            // Thousands digit rolls over to 0
                            q[15:12] <= 4'd0;
                        end else begin
                            q[15:12] <= digit3 + 1'b1;
                        end
                    end else begin
                        q[11:8] <= digit2 + 1'b1;
                    end
                end else begin
                    q[7:4] <= digit1 + 1'b1;
                end
            end else begin
                // Just increment ones digit
                q[3:0] <= digit0 + 1'b1;
            end
        end
    end
endmodule