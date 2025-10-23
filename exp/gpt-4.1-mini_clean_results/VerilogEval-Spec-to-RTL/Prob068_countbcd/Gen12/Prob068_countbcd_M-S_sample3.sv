module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] bcd;

    // Helper function: BCD addition by 1 on the least significant digit with correction
    // This is implemented in the always block for simplicity.

    // Enable signals: 
    // ena[0] - enable tens digit: when ones digit is 9
    // ena[1] - enable hundreds digit: when ones and tens digits are 9
    // ena[2] - enable thousands digit: when ones, tens, and hundreds digits are 9

    wire ones_is9     = (bcd[3:0]    == 4'd9);
    wire tens_is9     = (bcd[7:4]    == 4'd9);
    wire hundreds_is9 = (bcd[11:8]   == 4'd9);

    assign ena[0] = ones_is9;
    assign ena[1] = ones_is9 && tens_is9;
    assign ena[2] = ones_is9 && tens_is9 && hundreds_is9;

    always @(posedge clk) begin
        if (reset) begin
            bcd <= 16'd0;
        end else begin
            // Increment the BCD counter by 1 with proper BCD correction
            // Add 1 to the least significant nibble
            bcd[3:0] <= bcd[3:0] + 4'd1;

            // We need to correct each nibble if it exceeds 9 after addition
            // Since non-blocking assignments happen simultaneously, use a temp variable instead

            // Create a temporary variable for combinational correction
            // This requires a combinational process or a separate register update
            // We'll do it sequentially with a temporary variable for clarity

            // Since Verilog non-blocking assignment doesn't reflect immediately,
            // use a blocking variable inside always block to implement correction

            integer i;
            reg [15:0] temp;
            begin
                temp = {bcd[15:4], bcd[3:0] + 4'd1};

                // Check each nibble from least significant to most significant
                for (i = 0; i < 4; i = i + 1) begin
                    if (temp[i*4 +: 4] > 4'd9) begin
                        temp[i*4 +: 4] = temp[i*4 +: 4] + 4'd6; // Add 6 for BCD correction
                        if (i < 3)
                            temp[(i+1)*4 +:4] = temp[(i+1)*4 +:4] + 4'd1; // Carry to next digit
                    end
                end

                bcd <= temp;
            end
        end
    end

    assign q = bcd;

endmodule