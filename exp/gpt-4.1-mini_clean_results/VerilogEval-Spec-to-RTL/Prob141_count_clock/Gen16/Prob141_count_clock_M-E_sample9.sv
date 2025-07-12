module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Seconds BCD digits
    reg [3:0] ss_units;
    reg [3:0] ss_tens;
    wire      ss_rollover;

    // Minutes BCD digits
    reg [3:0] mm_units;
    reg [3:0] mm_tens;
    wire      mm_rollover;

    // Hours BCD digits (01 to 12)
    reg [3:0] hh_units;
    reg [3:0] hh_tens;

    // Seconds counter: counts from 00 to 59
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
            end
        end
    end

    assign ss_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);

    // Minutes counter: counts from 00 to 59, increments on seconds rollover
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (ena && ss_rollover) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                end else begin
                    mm_tens <= mm_tens + 4'd1;
                end
            end else begin
                mm_units <= mm_units + 4'd1;
            end
        end
    end

    assign mm_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Hours counter: counts from 01 to 12, increments on minutes rollover
    always @(posedge clk) begin
        if (reset) begin
            hh_tens  <= 4'd1; // '1' for tens digit of 12
            hh_units <= 4'd2; // '2' units digit of 12
            pm       <= 1'b0; // AM at reset
        end else if (ena && ss_rollover && mm_rollover) begin
            // Current hour in decimal: 10*hh_tens + hh_units
            // Increment hour
            if ( (hh_tens == 4'd1 && hh_units == 4'd2) ) begin
                // hour = 12 -> wrap to 01
                hh_tens  <= 4'd0;
                hh_units <= 4'd1;
                pm       <= ~pm; // Toggle pm at rollover 12 -> 1
            end else begin
                // Increment hour BCD properly
                if (hh_units == 4'd9) begin
                    hh_units <= 4'd0;
                    hh_tens  <= hh_tens + 4'd1;
                end else begin
                    hh_units <= hh_units + 4'd1;
                end
            end
        end
    end

    // Outputs assignments
    assign hh = {hh_tens, hh_units};
    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule