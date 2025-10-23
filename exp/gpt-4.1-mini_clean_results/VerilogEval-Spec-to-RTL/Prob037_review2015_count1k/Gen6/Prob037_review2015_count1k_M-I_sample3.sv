module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

    // 4-bit counters for each decimal digit
    reg [3:0] units;
    reg [3:0] tens;
    reg [3:0] hundreds;

    // Increment logic
    always @(posedge clk) begin
        if (reset) begin
            units <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
        end else begin
            if (units == 4'd9) begin
                units <= 4'd0;
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                    end else begin
                        hundreds <= hundreds + 4'd1;
                    end
                end else begin
                    tens <= tens + 4'd1;
                end
            end else begin
                units <= units + 4'd1;
            end
        end
    end

    // Combinational logic to convert BCD digits to binary count:
    // q = hundreds * 100 + tens * 10 + units
    // Implement multiplication by 100 and 10 using shifts and adds to reduce logic:
    // 100 = 64 + 32 + 4
    // 10  = 8 + 2

    wire [13:0] hundreds_x100;
    wire [11:0] tens_x10;

    assign hundreds_x100 = (hundreds << 6) + (hundreds << 5) + (hundreds << 2); // 64*H + 32*H + 4*H
    assign tens_x10 = (tens << 3) + (tens << 1);                                 // 8*T + 2*T

    always @(*) begin
        // Sum up all contributions, max value 999 fits in 10 bits
        q = hundreds_x100 + tens_x10 + units;
    end

endmodule