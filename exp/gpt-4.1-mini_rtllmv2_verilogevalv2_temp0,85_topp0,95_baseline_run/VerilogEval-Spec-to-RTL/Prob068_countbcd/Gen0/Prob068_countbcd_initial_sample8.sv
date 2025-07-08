module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            ena <= 3'b0;
            // Extract digits
            reg [3:0] ones, tens, hundreds, thousands;
            ones = q[3:0];
            tens = q[7:4];
            hundreds = q[11:8];
            thousands = q[15:12];

            // Increment ones
            if (ones == 9) begin
                ones = 0;
                ena[0] = 1'b1; // Enable tens increment

                // Increment tens
                if (tens == 9) begin
                    tens = 0;
                    ena[1] = 1'b1; // Enable hundreds increment

                    // Increment hundreds
                    if (hundreds == 9) begin
                        hundreds = 0;
                        ena[2] = 1'b1; // Enable thousands increment

                        // Increment thousands
                        if (thousands == 9) begin
                            thousands = 0; // Roll over after 9999
                        end else begin
                            thousands = thousands + 1;
                        end

                    end else begin
                        hundreds = hundreds + 1;
                    end

                end else begin
                    tens = tens + 1;
                end

            end else begin
                ones = ones + 1;
            end

            // Update q
            q <= {thousands, hundreds, tens, ones};
        end
    end

endmodule