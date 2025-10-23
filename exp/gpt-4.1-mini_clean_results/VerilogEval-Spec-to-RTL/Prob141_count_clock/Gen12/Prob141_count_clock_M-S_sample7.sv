module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;   // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;  // 12 o'clock
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Simple combinational BCD conversion by division and modulo
    wire [3:0] ss_tens = seconds / 10;
    wire [3:0] ss_units = seconds % 10;

    wire [3:0] mm_tens = minutes / 10;
    wire [3:0] mm_units = minutes % 10;

    wire [3:0] hh_tens = (hours >= 10) ? 4'd1 : 4'd0;
    wire [3:0] hh_units = (hours >= 10) ? hours - 4'd10 : hours;

    always @(*) begin
        ss = {ss_tens, ss_units};
        mm = {mm_tens, mm_units};
        hh = {hh_tens, hh_units};
    end

endmodule