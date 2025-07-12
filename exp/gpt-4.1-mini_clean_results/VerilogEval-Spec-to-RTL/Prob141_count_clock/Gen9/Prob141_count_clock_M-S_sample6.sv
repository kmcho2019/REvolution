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
            pm      <= 1'b0;
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    case (hours)
                        4'd11: begin
                            hours <= 4'd12;
                            pm <= ~pm;
                        end
                        4'd12: hours <= 4'd1;
                        default: hours <= hours + 1;
                    endcase
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Combinational BCD conversion by division and modulo (no multiplication)
    always @(*) begin
        ss[7:4] = seconds / 10;
        ss[3:0] = seconds % 10;

        mm[7:4] = minutes / 10;
        mm[3:0] = minutes % 10;

        hh[7:4] = hours / 10;
        hh[3:0] = hours % 10;
    end

endmodule