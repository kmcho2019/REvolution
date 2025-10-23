module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter counting from 0 to 99 for dividing 100MHz clock base
    reg [6:0] counter;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
        end else begin
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;
        end
    end

    // Output clock generation based on counter comparisons
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // CLK_50: 50MHz (period 2 cycles), high for 1 cycle (counter < 50 = half of 100)
            // Actually, CLK_50 toggles every cycle, but here output is high for half the counter range
            CLK_50 <= (counter < 7'd50);

            // CLK_10: 10MHz (period 10 cycles), high for 5 cycles (counter < 5)
            // The period is 10 cycles, so high when counter mod 10 < 5.
            // We derive this by modulo 10 operation: counter % 10 = lower 4 bits (since 10 is not power of two, use direct comparison)
            // Use remainder by subtracting multiples of 10.
            // To simplify, check counter modulo 10 using subtract-and-compare:
            // Extract mod 10 as (counter - 10 * (counter/10)), but division is complex.
            // Alternatively, use counter % 10 by encoding: counter[3:0] counts mod 16, but 10 is not power of 2.
            // We'll implement a small combinational function to get counter_mod10.

            // Implement mod 10 function
            // But since 100 is divisible by 10, counter cycles over 0-99,
            // so counter / 10 varies from 0 to 9, counter mod 10 varies from 0 to 9.
            // Use a combinational subtractive method for mod 10:

            // For simplicity, we compute counter_mod10 with a combinational logic:
            // The maximum counter is 99, so counter/10 is from 0 to 9.
            // Then counter_mod10 = counter - 10 * (counter / 10)

            // The result is done combinationally here:
            // We'll define a function below.
            // For synthesis, let's create a function in Verilog.

            // Compute counter_mod10
            // Then CLK_10 high if counter_mod10 < 5

            integer i;
            reg [3:0] counter_mod10;
            reg [3:0] quotient;
            begin
                quotient = 0;
                for (i = 9; i >= 0; i = i - 1) begin
                    if (counter >= i*10)
                        quotient = i;
                end
                counter_mod10 = counter - (quotient * 10);
                CLK_10 <= (counter_mod10 < 4'd5);
            end

            // CLK_1: 1MHz (period 100 cycles), high for 50 cycles (counter < 50)
            CLK_1 <= (counter < 7'd50);
        end
    end

endmodule