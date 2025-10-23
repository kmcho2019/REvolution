module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] bcd;

    wire [3:0] ones      = bcd[3:0];
    wire [3:0] tens      = bcd[7:4];
    wire [3:0] hundreds  = bcd[11:8];
    wire [3:0] thousands = bcd[15:12];

    reg ena1, ena2, ena3;

    // Assign ena output signals
    assign ena = {ena3, ena2, ena1};
    assign q = bcd;

    always @(posedge clk) begin
        if (reset) begin
            bcd   <= 16'd0;
            ena1 <= 1'b0;
            ena2 <= 1'b0;
            ena3 <= 1'b0;
        end else begin
            // Previous digits for carry detection
            wire carry_ones = (ones == 4'd9);
            wire carry_tens = (tens == 4'd9);
            wire carry_hundreds = (hundreds == 4'd9);

            // Increment ones digit by 1
            reg [15:0] bcd_next;
            bcd_next = bcd + 16'd1;

            // BCD correction: if any digit > 9, add 6 to that digit
            // For ones digit
            if (bcd_next[3:0] > 4'd9) 
                bcd_next[3:0] = bcd_next[3:0] + 4'd6;

            // For tens digit
            if (bcd_next[7:4] > 4'd9) 
                bcd_next[7:4] = bcd_next[7:4] + 4'd6;

            // For hundreds digit
            if (bcd_next[11:8] > 4'd9) 
                bcd_next[11:8] = bcd_next[11:8] + 4'd6;

            // For thousands digit
            if (bcd_next[15:12] > 4'd9) 
                bcd_next[15:12] = bcd_next[15:12] + 4'd6;

            bcd <= bcd_next;

            // Generate enable signals for upper digits based on carry conditions
            ena1 <= carry_ones;
            ena2 <= carry_ones && carry_tens;
            ena3 <= carry_ones && carry_tens && carry_hundreds;
        end
    end

endmodule