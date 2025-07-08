module TopModule(
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal wires for digits
    wire [3:0] ones = q[3:0];
    wire [3:0] tens = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Wires indicating carry out from each digit when rolling over 9->0
    wire ones_carry;
    wire tens_carry;
    wire hundreds_carry;

    // Increment logic
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b0;
        end else begin
            // Default ena signals off
            ena <= 3'b0;

            // Increment ones digit
            if (ones == 4'd9) begin
                // ones digit rolls over
                q[3:0] <= 4'd0;
                ena[0] <= 1'b1; // enable tens digit increment

                // Increment tens digit if enabled
                if (tens == 4'd9) begin
                    // tens digit rolls over
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1; // enable hundreds digit increment

                    // Increment hundreds digit if enabled
                    if (hundreds == 4'd9) begin
                        // hundreds digit rolls over
                        q[11:8] <= 4'd0;
                        ena[2] <= 1'b1; // enable thousands digit increment

                        // Increment thousands digit
                        if (thousands == 4'd9) begin
                            q[15:12] <= 4'd0;
                        end else begin
                            q[15:12] <= thousands + 1'b1;
                        end
                    end else begin
                        q[11:8] <= hundreds + 1'b1;
                    end
                end else begin
                    q[7:4] <= tens + 1'b1;
                end
            end else begin
                q[3:0] <= ones + 1'b1;
            end
        end
    end

endmodule