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
    wire ss_carry;

    // Minutes BCD digits
    reg [3:0] mm_units, mm_tens;
    wire mm_carry;

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    // Seconds counter block
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

    // Generate seconds carry: high when seconds roll over from 59 to 00
    assign ss_carry = (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;

    // Minutes counter block
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (ss_carry) begin
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

    // Generate minutes carry: high when minutes roll over from 59 to 00
    assign mm_carry = (mm_tens == 4'd5) && (mm_units == 4'd9) && ss_carry;

    // Hour counter block
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm <= 1'b0;
        end else if (mm_carry) begin
            if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end

            // Toggle pm when hour rolls from 11 to 12
            if (hour_bin == 4'd11) begin
                pm <= ~pm;
            end
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