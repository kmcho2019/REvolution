module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Seconds and minutes BCD digits
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Hour internal counter: 1 to 12
    reg [3:0] hour;

    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour     <= 4'd12;
            pm       <= 1'b0;
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
                            // Increment hour
                            if (hour == 4'd12) begin
                                hour <= 4'd1;
                            end else begin
                                hour <= hour + 4'd1;
                            end
                            // Toggle pm on hour rollover from 11 to 12
                            if (hour == 4'd11)
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

    // Convert internal hour (1-12) to BCD: tens digit is 1 if hour>9 else 0, units digit accordingly
    assign hh = (hour > 4'd9) ? {4'd1, hour - 4'd10} : {4'd0, hour};

    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule