module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal counters for seconds and minutes (BCD digits)
    reg [3:0] sec_units, min_units;
    reg [2:0] sec_tens, min_tens;

    // Internal hours counter in binary (1-12)
    reg [3:0] hours;

    // Next state signals
    reg [3:0] sec_units_next, min_units_next, hours_next;
    reg [2:0] sec_tens_next, min_tens_next;
    reg        pm_next;

    // Combinational logic to calculate next state
    always @* begin
        // Default next state to current
        sec_units_next = sec_units;
        sec_tens_next  = sec_tens;
        min_units_next = min_units;
        min_tens_next  = min_tens;
        hours_next     = hours;
        pm_next        = pm;

        if (ena) begin
            // Increment seconds units
            if (sec_units == 4'd9) begin
                sec_units_next = 4'd0;
                // Increment seconds tens
                if (sec_tens == 3'd5) begin
                    sec_tens_next = 3'd0;
                    // Increment minutes units
                    if (min_units == 4'd9) begin
                        min_units_next = 4'd0;
                        // Increment minutes tens
                        if (min_tens == 3'd5) begin
                            min_tens_next = 3'd0;
                            // Increment hours
                            if (hours == 4'd11) begin
                                hours_next = 4'd12;
                                pm_next = ~pm;  // Toggle PM on 11->12
                            end else if (hours == 4'd12) begin
                                hours_next = 4'd1;
                            end else begin
                                hours_next = hours + 1;
                            end
                        end else begin
                            min_tens_next = min_tens + 1;
                        end
                    end else begin
                        min_units_next = min_units + 1;
                    end
                end else begin
                    sec_tens_next = sec_tens + 1;
                end
            end else begin
                sec_units_next = sec_units + 1;
            end
        end
    end

    // Sequential logic to update state registers
    always @(posedge clk) begin
        if (reset) begin
            pm        <= 1'b0;
            sec_units <= 4'd0;
            sec_tens  <= 3'd0;
            min_units <= 4'd0;
            min_tens  <= 3'd0;
            hours     <= 4'd12;
        end else begin
            pm        <= pm_next;
            sec_units <= sec_units_next;
            sec_tens  <= sec_tens_next;
            min_units <= min_units_next;
            min_tens  <= min_tens_next;
            hours     <= hours_next;
        end
    end

    // Function to convert 1-12 binary hours to BCD 8-bit (tens and units)
    function [7:0] bin_to_bcd_12h;
        input [3:0] h;
        begin
            if (h >= 10)
                bin_to_bcd_12h = {4'd1, h - 4'd10};
            else
                bin_to_bcd_12h = {4'd0, h};
        end
    endfunction

    // Output assignment combinationally
    always @* begin
        hh = bin_to_bcd_12h(hours);
        mm = {min_tens, min_units};
        ss = {sec_tens, sec_units};
    end

endmodule