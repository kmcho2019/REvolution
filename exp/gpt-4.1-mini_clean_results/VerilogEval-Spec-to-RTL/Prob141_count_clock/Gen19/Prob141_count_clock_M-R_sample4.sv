module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] hour_bin;  // 1 to 12 in binary

    // Helper function for BCD increment with wrap-around for digits and carry
    function [8:0] bcd_increment_59; // returns 9 bits: {carry, bcd}
        input [7:0] bcd_in;
        reg [3:0] ones, tens;
        reg carry_ones, carry_tens;
        begin
            ones = bcd_in[3:0];
            tens = bcd_in[7:4];
            carry_ones = (ones == 4'd9);
            if (carry_ones) begin
                ones = 4'd0;
                carry_tens = (tens == 4'd5);
                if (carry_tens) begin
                    tens = 4'd0;
                    bcd_increment_59 = {1'b1, {tens, ones}}; // carry out = 1
                end else begin
                    tens = tens + 4'd1;
                    bcd_increment_59 = {1'b0, {tens, ones}};
                end
            end else begin
                ones = ones + 4'd1;
                bcd_increment_59 = {1'b0, {tens, ones}};
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hour_bin <= 4'd12;
            pm <= 1'b0;
        end else if (ena) begin
            // Increment seconds and get carry out if rolled over
            {wire sec_carry, wire [7:0] ss_next} = bcd_increment_59(ss);
            ss <= ss_next;

            if (sec_carry) begin
                // Increment minutes and get carry out if rolled over
                {wire min_carry, wire [7:0] mm_next} = bcd_increment_59(mm);
                mm <= mm_next;

                if (min_carry) begin
                    // Increment hour binary with wrap 1..12
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end
                    // Toggle pm on hour transition from 11 to 12
                    if (hour_bin == 4'd11) begin
                        pm <= ~pm;
                    end
                end
            end
        end
    end

    // Combinational BCD encoding of hour_bin
    assign hh = (hour_bin > 4'd9) ? {4'd1, hour_bin - 4'd10} : {4'd0, hour_bin};

endmodule