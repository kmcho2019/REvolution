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

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    // Carry registers to pipeline the rollover signals
    reg sec_carry;
    reg min_carry;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            sec_carry <= 1'b0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    sec_carry <= 1'b1;  // Seconds rolled over from 59 to 00
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                    sec_carry <= 1'b0;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
                sec_carry <= 1'b0;
            end
        end else begin
            sec_carry <= 1'b0; // Clear carry if not enabled
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            min_carry <= 1'b0;
        end else if (sec_carry && ena) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                    min_carry <= 1'b1;  // Minutes rolled over from 59 to 00
                end else begin
                    mm_tens <= mm_tens + 4'd1;
                    min_carry <= 1'b0;
                end
            end else begin
                mm_units <= mm_units + 4'd1;
                min_carry <= 1'b0;
            end
        end else if (reset) begin
            min_carry <= 1'b0;
        end else begin
            min_carry <= 1'b0;
        end
    end

    // Hours and pm flag counter
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm <= 1'b0; // AM
        end else if (min_carry && ena) begin
            if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end

            // Toggle pm when hour increments from 11 to 12
            if (hour_bin == 4'd11) begin
                pm <= ~pm;
            end
        end
    end

    // Hours BCD conversion from binary hour_bin (1..12)
    // Output format: [tens][units]
    assign hh = (hour_bin > 4'd9) ? {4'd1, hour_bin - 4'd10} : {4'd0, hour_bin};

    // Minutes and seconds output as concatenation of tens and units digits
    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule