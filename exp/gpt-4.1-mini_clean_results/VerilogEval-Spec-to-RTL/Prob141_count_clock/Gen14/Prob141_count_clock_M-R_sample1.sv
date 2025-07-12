module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits for seconds, minutes, hours
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens;  // Hour digits directly stored as BCD (01 to 12)

// Single synchronous always block for all updates
always @(posedge clk) begin
    if (reset) begin
        // Reset time to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2;  // '2' for hour digit units of 12
        hh_tens  <= 4'd1;  // '1' for hour digit tens of 12
        pm       <= 1'b0;  // AM
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                
                // Increment minutes at seconds rollover
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        
                        // Increment hours at minutes rollover
                        if (hh_tens == 4'd1 && hh_units == 4'd2) begin
                            // Hour is 12, roll to 1
                            hh_tens <= 4'd0;
                            hh_units <= 4'd1;
                            pm <= ~pm; // Toggle pm when going from 12 to 1
                        end else begin
                            // Increment hour BCD (1 to 11)
                            if (hh_units == 4'd9) begin
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 4'd1;
                            end else begin
                                hh_units <= hh_units + 4'd1;
                            end
                        end
                        
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

// Combine digits into outputs
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule