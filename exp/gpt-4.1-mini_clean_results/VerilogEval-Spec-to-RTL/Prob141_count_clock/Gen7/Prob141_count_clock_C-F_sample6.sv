module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hour internal binary counter (1 to 12)
reg [3:0] hour_bin; // values 1 to 12

// Function: Convert binary hour (1..12) to BCD
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        if (bin_hour <= 4'd9)
            bin_to_bcd_hour = {4'd0, bin_hour}; // tens=0, units=bin_hour
        else
            bin_to_bcd_hour = {4'd1, bin_hour - 4'd10}; // tens=1, units=bin_hour-10
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        pm        <= 1'b0;       // AM
        hour_bin  <= 4'd12;      // 12
        mm_tens   <= 4'd0;
        mm_units  <= 4'd0;
        ss_tens   <= 4'd0;
        ss_units  <= 4'd0;
    end else if (ena) begin
        // Increment seconds units
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            // Increment seconds tens
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes units
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    // Increment minutes tens
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hours binary counter
                        if (hour_bin == 4'd12) begin
                            hour_bin <= 4'd1;
                        end else begin
                            hour_bin <= hour_bin + 4'd1;
                        end
                        // Toggle PM at rollover from 11->12
                        if (hour_bin == 4'd11)
                            pm <= ~pm;
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end
            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

// Outputs combinationally assigned
always @* begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule