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
    reg [3:0] ss_units, ss_tens;
    reg        ss_rollover; // registered carry to next counter

    // Minutes BCD digits
    reg [3:0] mm_units, mm_tens;
    reg        mm_rollover; // registered carry to next counter

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    // Carry signals between counters, registered to break combinational chain
    reg ss_carry;
    reg mm_carry;
    reg pm_toggle_pending;

    // Seconds counter: increments on ena
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            ss_carry <= 1'b0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens  <= 4'd0;
                    ss_carry <= 1'b1; // seconds rolled over
                end else begin
                    ss_tens  <= ss_tens + 4'd1;
                    ss_carry <= 1'b0;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
                ss_carry <= 1'b0;
            end
        end else begin
            ss_carry <= 1'b0;
        end
    end

    // Minutes counter: increments on ss_carry registered last cycle
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            mm_carry <= 1'b0;
        end else if (ss_carry) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens  <= 4'd0;
                    mm_carry <= 1'b1; // minutes rolled over
                end else begin
                    mm_tens  <= mm_tens + 4'd1;
                    mm_carry <= 1'b0;
                end
            end else begin
                mm_units <= mm_units + 4'd1;
                mm_carry <= 1'b0;
            end
        end else begin
            mm_carry <= 1'b0;
        end
    end

    // Hour counter: increments on mm_carry registered last cycle
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            pm_toggle_pending <= 1'b0;
        end else begin
            if (mm_carry) begin
                if (hour_bin == 4'd12) begin
                    hour_bin <= 4'd1;
                end else begin
                    hour_bin <= hour_bin + 4'd1;
                end

                // Toggle pm when hour rolls from 11 to 12
                pm_toggle_pending <= (hour_bin == 4'd11);
            end else begin
                pm_toggle_pending <= 1'b0;
            end

            // Toggle pm synchronously next cycle if pending
            if (pm_toggle_pending)
                pm <= ~pm;
        end
    end

    // Output assignments

    // Hours BCD conversion from binary hour_bin (1..12)
    // Output format: [tens][units]
    assign hh = (hour_bin > 4'd9) ? {4'd1, hour_bin - 4'd10} : {4'd0, hour_bin};

    // Minutes and seconds output as concatenation of tens and units digits
    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule