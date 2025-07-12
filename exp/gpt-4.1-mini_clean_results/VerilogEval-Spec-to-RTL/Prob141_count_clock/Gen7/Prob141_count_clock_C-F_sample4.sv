module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Internal binary hour counter (1 to 12)
reg [3:0] hour_bin; // 4 bits sufficient for 1..12

// Next state signals for seconds and minutes BCD digits
reg [3:0] next_ss_units, next_ss_tens;
reg [3:0] next_mm_units, next_mm_tens;
reg [3:0] next_hour_bin;
reg       next_pm;

// Helper function to increment BCD digit with max rollover
function [3:0] inc_bcd_digit(input [3:0] digit, input [3:0] max_val);
    begin
        if (digit == max_val)
            inc_bcd_digit = 4'd0;
        else
            inc_bcd_digit = digit + 4'd1;
    end
endfunction

// Hour binary increment logic: increments 1 to 12 circularly
// Will be used in combinational next-state calculation

// Combinational next-state logic
always @* begin
    // Default assign current values as next values
    next_ss_units = ss_units;
    next_ss_tens  = ss_tens;
    next_mm_units = mm_units;
    next_mm_tens  = mm_tens;
    next_hour_bin = hour_bin;
    next_pm       = pm;

    if (ena) begin
        // Increment seconds units digit
        if (ss_units == 4'd9) begin
            next_ss_units = 4'd0;
            // Increment seconds tens digit
            if (ss_tens == 4'd5) begin
                next_ss_tens = 4'd0;
                // Increment minutes units digit
                if (mm_units == 4'd9) begin
                    next_mm_units = 4'd0;
                    // Increment minutes tens digit
                    if (mm_tens == 4'd5) begin
                        next_mm_tens = 4'd0;
                        // Increment hour binary counter (1 to 12)
                        if (hour_bin == 4'd12)
                            next_hour_bin = 4'd1;
                        else
                            next_hour_bin = hour_bin + 4'd1;

                        // Toggle pm when hour rolls from 11 to 12
                        if (hour_bin == 4'd11)
                            next_pm = ~pm;
                    end else begin
                        next_mm_tens = mm_tens + 4'd1;
                    end
                end else begin
                    next_mm_units = mm_units + 4'd1;
                end
            end else begin
                next_ss_tens = ss_tens + 4'd1;
            end
        end else begin
            next_ss_units = ss_units + 4'd1;
        end
    end
end

// Function to convert binary hour (1..12) to BCD for output
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    reg [7:0] val;
    begin
        if (bin_hour <= 4'd9) begin
            // Hours 1 to 9: tens=0, units=bin_hour
            val = {4'd0, bin_hour};
        end else begin
            // Hours 10 to 12: tens=1, units=bin_hour-10
            val = {4'd1, bin_hour - 4'd10};
        end
        bin_to_bcd_hour = val;
    end
endfunction

// Sequential logic with synchronous reset and state updates
always @(posedge clk) begin
    if (reset) begin
        pm        <= 1'b0;     // AM
        hour_bin  <= 4'd12;    // 12 o'clock start
        mm_tens   <= 4'd0;
        mm_units  <= 4'd0;
        ss_tens   <= 4'd0;
        ss_units  <= 4'd0;
    end else begin
        pm        <= next_pm;
        hour_bin  <= next_hour_bin;
        mm_tens   <= next_mm_tens;
        mm_units  <= next_mm_units;
        ss_tens   <= next_ss_tens;
        ss_units  <= next_ss_units;
    end
end

// Outputs combinationally assigned from registers
always @* begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule