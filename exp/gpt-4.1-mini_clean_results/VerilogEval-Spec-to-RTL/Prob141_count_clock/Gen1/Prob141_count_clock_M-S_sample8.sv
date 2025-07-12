module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal BCD digits
    reg [3:0] hh_tens, hh_ones;
    reg [3:0] mm_tens, mm_ones;
    reg [3:0] ss_tens, ss_ones;

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;       // AM
            hh_tens <= 4'd1;  // '1'
            hh_ones <= 4'd2;  // '2' => 12
            mm_tens <= 4'd0;
            mm_ones <= 4'd0;
            ss_tens <= 4'd0;
            ss_ones <= 4'd0;
        end else if (ena) begin
            // Increment seconds
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Increment minutes
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Increment hours (1 to 12 BCD)
                            if (hh_tens == 4'd1) begin
                                if (hh_ones == 4'd2) begin
                                    // From 12 to 1, toggle pm
                                    hh_tens <= 4'd0;
                                    hh_ones <= 4'd1;
                                    pm <= ~pm;
                                end else begin
                                    // 10, 11 -> next hour
                                    hh_ones <= hh_ones + 1;
                                end
                            end else begin
                                // hh_tens == 0, so 01 to 09
                                if (hh_ones == 4'd9) begin
                                    hh_ones <= 4'd0;
                                    hh_tens <= 4'd1; // go to 10
                                end else begin
                                    hh_ones <= hh_ones + 1;
                                end
                            end
                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    // Pack outputs from BCD digits
    always @(*) begin
        hh = {hh_tens, hh_ones};
        mm = {mm_tens, mm_ones};
        ss = {ss_tens, ss_ones};
    end

endmodule