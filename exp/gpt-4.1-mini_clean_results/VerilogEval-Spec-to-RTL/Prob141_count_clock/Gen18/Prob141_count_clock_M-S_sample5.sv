module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Seconds counter: BCD two digits (00 to 59)
    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
        end else if (ena) begin
            if (ss[3:0] == 4'd9) begin
                if (ss[7:4] == 4'd5)
                    ss <= 8'h00;
                else
                    ss <= {ss[7:4] + 4'd1, 4'd0};
            end else begin
                ss <= {ss[7:4], ss[3:0] + 4'd1};
            end
        end
    end

    // Minute carry: true if seconds rolled over from 59 to 00
    wire sec_rollover = (ss == 8'h59) && ena;

    // Minutes counter: BCD two digits (00 to 59)
    always @(posedge clk) begin
        if (reset) begin
            mm <= 8'h00;
        end else if (sec_rollover) begin
            if (mm[3:0] == 4'd9) begin
                if (mm[7:4] == 4'd5)
                    mm <= 8'h00;
                else
                    mm <= {mm[7:4] + 4'd1, 4'd0};
            end else begin
                mm <= {mm[7:4], mm[3:0] + 4'd1};
            end
        end
    end

    // Minute carry: true if minutes rolled over from 59 to 00
    wire min_rollover = (mm == 8'h59) && sec_rollover;

    // Hour counter: binary 1..12
    reg [3:0] hour_bin;
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm <= 1'b0;
        end else if (min_rollover) begin
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

    // Hour output: convert binary hour to BCD (01 to 12)
    assign hh = (hour_bin > 4'd9) ? {4'd1, hour_bin - 4'd10} : {4'd0, hour_bin};

endmodule