module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal wires for digits
    wire [3:0] digit0 = q[3:0];    // ones
    wire [3:0] digit1 = q[7:4];    // tens
    wire [3:0] digit2 = q[11:8];   // hundreds
    wire [3:0] digit3 = q[15:12];  // thousands

    // Signals to indicate if a digit reached 9 and will rollover on next increment
    wire digit0_rollover = (digit0 == 4'd9);
    wire digit1_rollover = (digit1 == 4'd9);
    wire digit2_rollover = (digit2 == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Default ena signals to 0
            ena <= 3'b000;

            // Increment the ones digit
            if (digit0 == 4'd9) begin
                // Rollover ones to 0, enable tens
                q[3:0] <= 4'd0;
                ena[0] <= 1'b1;

                // Check if tens digit needs to increment
                if (digit1 == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1;

                    // Check if hundreds digit needs to increment
                    if (digit2 == 4'd9) begin
                        q[11:8] <= 4'd0;
                        ena[2] <= 1'b1;

                        // Increment thousands digit, roll over to 0 after 9
                        if (digit3 == 4'd9) begin
                            q[15:12] <= 4'd0;
                        end else begin
                            q[15:12] <= digit3 + 4'd1;
                        end

                    end else begin
                        // Increment hundreds digit
                        q[11:8] <= digit2 + 4'd1;
                    end

                end else begin
                    // Increment tens digit
                    q[7:4] <= digit1 + 4'd1;
                end

            end else begin
                // Increment ones digit only
                q[3:0] <= digit0 + 4'd1;
            end
        end
    end

endmodule