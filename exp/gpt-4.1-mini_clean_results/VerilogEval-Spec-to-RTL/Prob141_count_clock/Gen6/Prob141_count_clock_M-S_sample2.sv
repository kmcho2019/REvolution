module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD digits for seconds, minutes, hours
    reg [3:0] ss_u, ss_t;
    reg [3:0] mm_u, mm_t;
    reg [3:0] hh_u, hh_t;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm   <= 0;
            hh_t <= 4'd1; // '1'
            hh_u <= 4'd2; // '2' => 12
            mm_t <= 4'd0;
            mm_u <= 4'd0;
            ss_t <= 4'd0;
            ss_u <= 4'd0;
        end else if (ena) begin
            // Increment seconds units
            if (ss_u == 4'd9) begin
                ss_u <= 4'd0;
                // Increment seconds tens
                if (ss_t == 4'd5) begin
                    ss_t <= 4'd0;
                    // Increment minutes units
                    if (mm_u == 4'd9) begin
                        mm_u <= 4'd0;
                        // Increment minutes tens
                        if (mm_t == 4'd5) begin
                            mm_t <= 4'd0;
                            // Increment hours (12-hour format)
                            if (hh_t == 4'd1 && hh_u == 4'd2) begin
                                // hour = 12, next is 1, toggle pm
                                hh_t <= 4'd0;
                                hh_u <= 4'd1;
                                pm <= ~pm;
                            end else if (hh_t == 4'd0 && hh_u == 4'd9) begin
                                // hour = 9, next is 10
                                hh_t <= 4'd1;
                                hh_u <= 4'd0;
                            end else begin
                                // increment hour units
                                if (hh_u == 4'd9) begin
                                    hh_u <= 4'd0;
                                    hh_t <= hh_t + 4'd1;
                                end else begin
                                    hh_u <= hh_u + 4'd1;
                                end
                            end
                        end else begin
                            mm_t <= mm_t + 4'd1;
                        end
                    end else begin
                        mm_u <= mm_u + 4'd1;
                    end
                end else begin
                    ss_t <= ss_t + 4'd1;
                end
            end else begin
                ss_u <= ss_u + 4'd1;
            end
        end
    end

    // Outputs are concatenation of digits
    always @(*) begin
        hh = {hh_t, hh_u};
        mm = {mm_t, mm_u};
        ss = {ss_t, ss_u};
    end

endmodule