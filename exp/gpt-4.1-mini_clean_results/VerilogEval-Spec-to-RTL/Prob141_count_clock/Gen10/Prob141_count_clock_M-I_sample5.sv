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

// Sequential logic to increment seconds and cascade increments to minutes and hours
always @(posedge clk) begin
    if (reset) begin
        pm        <= 1'b0;     // AM
        hour_bin  <= 4'd12;    // Start at 12
        mm_tens   <= 4'd0;
        mm_units  <= 4'd0;
        ss_tens   <= 4'd0;
        ss_units  <= 4'd0;
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hours binary counter with wrap 1..12
                        if (hour_bin == 4'd12)
                            hour_bin <= 4'd1;
                        else
                            hour_bin <= hour_bin + 4'd1;

                        // Toggle pm on hour roll from 11 to 12
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

// Hour binary to BCD conversion with a small combinational lookup for better timing
always @(*) begin
    case (hour_bin)
        4'd1:  hh = 8'h01;
        4'd2:  hh = 8'h02;
        4'd3:  hh = 8'h03;
        4'd4:  hh = 8'h04;
        4'd5:  hh = 8'h05;
        4'd6:  hh = 8'h06;
        4'd7:  hh = 8'h07;
        4'd8:  hh = 8'h08;
        4'd9:  hh = 8'h09;
        4'd10: hh = 8'h10;
        4'd11: hh = 8'h11;
        4'd12: hh = 8'h12;
        default: hh = 8'h12; // fallback
    endcase
end

// Outputs for minutes and seconds assigned combinationally from BCD digits
always @(*) begin
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule