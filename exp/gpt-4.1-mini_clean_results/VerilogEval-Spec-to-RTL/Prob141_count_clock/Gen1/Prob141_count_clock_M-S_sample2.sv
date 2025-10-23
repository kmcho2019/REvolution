module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Increment BCD 00-59 counter
function [7:0] inc_59(input [7:0] bcd);
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
    inc_59 = {tens, ones};
end
endfunction

// Check if BCD 00-59 counter overflowed (i.e. was 59)
function is_59(input [7:0] bcd);
begin
    is_59 = (bcd == 8'h59);
end
endfunction

// Increment BCD hour counter 01-12 with overflow flag
function [8:0] inc_12(input [7:0] bcd);
    reg [3:0] ones, tens;
    reg [7:0] next;
    reg overflow_flag;
begin
    ones = bcd[3:0];
    tens = bcd[7:4];

    if (ones == 4'd9) begin
        ones = 4'd0;
        tens = tens + 4'd1;
    end else begin
        ones = ones + 4'd1;
    end
    next = {tens, ones};

    // Correct next hour BCD for range 01-12:
    // If next > 12, roll to 01 and overflow
    if ((tens > 4'd1) || (tens == 4'd1 && ones > 4'd2) || (next == 8'h00)) begin
        next = 8'h01;
        overflow_flag = 1'b1;
    end else begin
        overflow_flag = 1'b0;
    end

    inc_12 = {overflow_flag, next};
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12; // 12 in BCD
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;  // AM
    end else if (ena) begin
        // Increment seconds
        if (is_59(ss)) begin
            ss <= 8'h00;
            // Increment minutes
            if (is_59(mm)) begin
                mm <= 8'h00;
                // Increment hours
                reg overflow_hour;
                reg [7:0] new_hh;
                {overflow_hour, new_hh} = inc_12(hh);
                hh <= new_hh;
                if (overflow_hour)
                    pm <= ~pm; // toggle pm at 12->1 rollover
            end else begin
                mm <= inc_59(mm);
            end
        end else begin
            ss <= inc_59(ss);
        end
    end
end

endmodule