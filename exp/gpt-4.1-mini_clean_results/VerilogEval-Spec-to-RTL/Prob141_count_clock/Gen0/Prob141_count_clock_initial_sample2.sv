module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment BCD from 00 to 59 or 01 to 12 depending on max
function [7:0] bcd_increment_59(input [7:0] bcd);
    reg [3:0] ones, tens;
    begin
        ones = bcd[3:0];
        tens = bcd[7:4];
        if (ones == 4'd9) begin
            ones = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else
            ones = ones + 4'd1;
        bcd_increment_59 = {tens, ones};
    end
endfunction

// Function to increment hours BCD from 01 to 12, returns new value and overflow flag
function [8:0] bcd_increment_12(input [7:0] bcd);
    reg [7:0] next;
    reg overflow;
    reg [3:0] ones, tens;
    begin
        ones = bcd[3:0];
        tens = bcd[7:4];

        // increment by 1
        if (ones == 4'd9) begin
            ones = 4'd0;
            tens = tens + 4'd1;
        end else
            ones = ones + 4'd1;

        next = {tens, ones};

        // Adjust for valid hour range 01-12:
        // After 12 -> 01 and overflow
        if (next == 8'd13) begin // bcd 0001 0011 (19 decimal) but we check differently:
            // 12 decimal is 0x12, 13 decimal is 0x13 in BCD; check tens==1 and ones==3
            // So check if tens==1 and ones==3
            next = 8'h01; // 01
            overflow = 1'b1;
        end else if (tens > 4'd1 || (tens == 4'd1 && ones > 4'd2)) begin
            // If somehow invalid BCD (e.g. 1x > 12), wrap to 1
            next = 8'h01;
            overflow = 1'b1;
        end else if (next == 8'h00) begin
            // Hour can't be zero, wrap to 01
            next = 8'h01;
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end

        bcd_increment_12 = {overflow, next};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset time to 12:00 AM
        hh <= 8'h12; // 0x12 = BCD 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        ss <= bcd_increment_59(ss);
        if (ss == 8'h59) begin
            // Seconds about to wrap, increment minutes next cycle
            mm <= bcd_increment_59(mm);
            if (mm == 8'h59) begin
                // Minutes about to wrap, increment hours next cycle
                // Handle hour increment and pm toggle
                // unpack function result
                reg overflow;
                reg [7:0] newhh;
                {overflow, newhh} = bcd_increment_12(hh);
                hh <= newhh;
                if (overflow)
                    pm <= ~pm; // toggle pm on hour rollover from 12 to 1
            end
        end
    end
end

endmodule