module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [31:0] seconds_counter;
reg [7:0] hours_reg;
reg [7:0] minutes_reg;
reg [7:0] seconds_reg;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds_counter <= 32'd0;
        hours_reg <= 8'd12;
        minutes_reg <= 8'd0;
        seconds_reg <= 8'd0;
        pm_reg <= 1'b0;
    end else if (ena) begin
        seconds_counter <= seconds_counter + 1;
        if (seconds_counter == 32'd60) begin
            seconds_counter <= 32'd0;
            if (minutes_reg == 8'd59) begin
                minutes_reg <= 8'd0;
                if (hours_reg == 8'd12) begin
                    hours_reg <= 8'd1;
                    pm_reg <= ~pm_reg;
                end else if (hours_reg == 8'd11) begin
                    hours_reg <= 8'd12;
                end else begin
                    hours_reg <= hours_reg + 8'd1;
                end
            end else begin
                minutes_reg <= minutes_reg + 8'd1;
            end
        end else if (seconds_counter == 32'd1) begin
            seconds_reg <= 8'd1;
        end else if (seconds_counter == 32'd2) begin
            seconds_reg <= 8'd2;
        end else if (seconds_counter == 32'd3) begin
            seconds_reg <= 8'd3;
        end else if (seconds_counter == 32'd4) begin
            seconds_reg <= 8'd4;
        end else if (seconds_counter == 32'd5) begin
            seconds_reg <= 8'd5;
        end else if (seconds_counter == 32'd6) begin
            seconds_reg <= 8'd6;
        end else if (seconds_counter == 32'd7) begin
            seconds_reg <= 8'd7;
        end else if (seconds_counter == 32'd8) begin
            seconds_reg <= 8'd8;
        end else if (seconds_counter == 32'd9) begin
            seconds_reg <= 8'd9;
        end else if (seconds_counter == 32'd10) begin
            seconds_reg <= 8'd10;
        end else if (seconds_counter == 32'd11) begin
            seconds_reg <= 8'd11;
        end else if (seconds_counter == 32'd12) begin
            seconds_reg <= 8'd12;
        end else if (seconds_counter == 32'd13) begin
            seconds_reg <= 8'd13;
        end else if (seconds_counter == 32'd14) begin
            seconds_reg <= 8'd14;
        end else if (seconds_counter == 32'd15) begin
            seconds_reg <= 8'd15;
        end else if (seconds_counter == 32'd16) begin
            seconds_reg <= 8'd16;
        end else if (seconds_counter == 32'd17) begin
            seconds_reg <= 8'd17;
        end else if (seconds_counter == 32'd18) begin
            seconds_reg <= 8'd18;
        end else if (seconds_counter == 32'd19) begin
            seconds_reg <= 8'd19;
        end else if (seconds_counter == 32'd20) begin
            seconds_reg <= 8'd20;
        end else if (seconds_counter == 32'd21) begin
            seconds_reg <= 8'd21;
        end else if (seconds_counter == 32'd22) begin
            seconds_reg <= 8'd22;
        end else if (seconds_counter == 32'd23) begin
            seconds_reg <= 8'd23;
        end else if (seconds_counter == 32'd24) begin
            seconds_reg <= 8'd24;
        end else if (seconds_counter == 32'd25) begin
            seconds_reg <= 8'd25;
        end else if (seconds_counter == 32'd26) begin
            seconds_reg <= 8'd26;
        end else if (seconds_counter == 32'd27) begin
            seconds_reg <= 8'd27;
        end else if (seconds_counter == 32'd28) begin
            seconds_reg <= 8'd28;
        end else if (seconds_counter == 32'd29) begin
            seconds_reg <= 8'd29;
        end else if (seconds_counter == 32'd30) begin
            seconds_reg <= 8'd30;
        end else if (seconds_counter == 32'd31) begin
            seconds_reg <= 8'd31;
        end else if (seconds_counter == 32'd32) begin
            seconds_reg <= 8'd32;
        end else if (seconds_counter == 32'd33) begin
            seconds_reg <= 8'd33;
        end else if (seconds_counter == 32'd34) begin
            seconds_reg <= 8'd34;
        end else if (seconds_counter == 32'd35) begin
            seconds_reg <= 8'd35;
        end else if (seconds_counter == 32'd36) begin
            seconds_reg <= 8'd36;
        end else if (seconds_counter == 32'd37) begin
            seconds_reg <= 8'd37;
        end else if (seconds_counter == 32'd38) begin
            seconds_reg <= 8'd38;
        end else if (seconds_counter == 32'd39) begin
            seconds_reg <= 8'd39;
        end else if (seconds_counter == 32'd40) begin
            seconds_reg <= 8'd40;
        end else if (seconds_counter == 32'd41) begin
            seconds_reg <= 8'd41;
        end else if (seconds_counter == 32'd42) begin
            seconds_reg <= 8'd42;
        end else if (seconds_counter == 32'd43) begin
            seconds_reg <= 8'd43;
        end else if (seconds_counter == 32'd44) begin
            seconds_reg <= 8'd44;
        end else if (seconds_counter == 32'd45) begin
            seconds_reg <= 8'd45;
        end else if (seconds_counter == 32'd46) begin
            seconds_reg <= 8'd46;
        end else if (seconds_counter == 32'd47) begin
            seconds_reg <= 8'd47;
        end else if (seconds_counter == 32'd48) begin
            seconds_reg <= 8'd48;
        end else if (seconds_counter == 32'd49) begin
            seconds_reg <= 8'd49;
        end else if (seconds_counter == 32'd50) begin
            seconds_reg <= 8'd50;
        end else if (seconds_counter == 32'd51) begin
            seconds_reg <= 8'd51;
        end else if (seconds_counter == 32'd52) begin
            seconds_reg <= 8'd52;
        end else if (seconds_counter == 32'd53) begin
            seconds_reg <= 8'd53;
        end else if (seconds_counter == 32'd54) begin
            seconds_reg <= 8'd54;
        end else if (seconds_counter == 32'd55) begin
            seconds_reg <= 8'd55;
        end else if (seconds_counter == 32'd56) begin
            seconds_reg <= 8'd56;
        end else if (seconds_counter == 32'd57) begin
            seconds_reg <= 8'd57;
        end else if (seconds_counter == 32'd58) begin
            seconds_reg <= 8'd58;
        end else if (seconds_counter == 32'd59) begin
            seconds_reg <= 8'd59;
        end
    end
end

assign pm = pm_reg;
assign hh = hours_reg;
assign mm = minutes_reg;
assign ss = seconds_reg;

endmodule