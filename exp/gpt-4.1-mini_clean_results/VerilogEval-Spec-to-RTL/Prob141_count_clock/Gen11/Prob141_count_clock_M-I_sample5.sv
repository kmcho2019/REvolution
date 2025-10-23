module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Internal binary hour counter (1 to 12)
reg [3:0] hour_bin; // 4 bits sufficient for 1..12

// Carry signals for incrementing time
wire sec_carry, min_carry, hour_carry;

// Increment seconds BCD digits and generate carry
assign sec_carry = (ss_tens == 4'd5) && (ss_units == 4'd9);

wire [3:0] ss_units_next = (ss_units == 4'd9) ? 4'd0 : ss_units + 4'd1;
wire [3:0] ss_tens_next  = sec_carry ? 4'd0 :
                          (ss_units == 4'd9) ? ss_tens + 4'd1 : ss_tens;

// Increment minutes BCD digits and generate carry, only if seconds rolled over
assign min_carry = (mm_tens == 4'd5) && (mm_units == 4'd9);

wire [3:0] mm_units_next = (ena && sec_carry) ? ((mm_units == 4'd9) ? 4'd0 : mm_units + 4'd1) : mm_units;
wire [3:0] mm_tens_next  = (ena && sec_carry) ? (min_carry ? 4'd0 : ((mm_units == 4'd9) ? mm_tens + 4'd1 : mm_tens)) : mm_tens;

// Increment hour binary counter and toggle pm, only if minutes rolled over and enable asserted
assign hour_carry = (hour_bin == 4'd12);

wire [3:0] hour_bin_next;
wire       pm_next;

assign hour_bin_next = (ena && sec_carry && min_carry) ? ((hour_bin == 4'd12) ? 4'd1 : hour_bin + 4'd1) : hour_bin;
assign pm_next = (ena && sec_carry && min_carry && (hour_bin == 4'd11)) ? ~pm : pm;

// Function to convert binary hour (1..12) to BCD for output using case
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        case (bin_hour)
            4'd1:  bin_to_bcd_hour = 8'h01;
            4'd2:  bin_to_bcd_hour = 8'h02;
            4'd3:  bin_to_bcd_hour = 8'h03;
            4'd4:  bin_to_bcd_hour = 8'h04;
            4'd5:  bin_to_bcd_hour = 8'h05;
            4'd6:  bin_to_bcd_hour = 8'h06;
            4'd7:  bin_to_bcd_hour = 8'h07;
            4'd8:  bin_to_bcd_hour = 8'h08;
            4'd9:  bin_to_bcd_hour = 8'h09;
            4'd10: bin_to_bcd_hour = 8'h10;
            4'd11: bin_to_bcd_hour = 8'h11;
            4'd12: bin_to_bcd_hour = 8'h12;
            default: bin_to_bcd_hour = 8'h00; // Should never happen
        endcase
    end
endfunction

// Sequential logic with synchronous reset and state updates
always @(posedge clk) begin
    if (reset) begin
        pm        <= 1'b0;     // AM
        hour_bin  <= 4'd12;    // 12 o'clock start
        mm_tens   <= 4'd0;
        mm_units  <= 4'd0;
        ss_tens   <= 4'd0;
        ss_units  <= 4'd0;
        hh        <= 8'h12;    // "12"
        mm        <= 8'd0;
        ss        <= 8'd0;
    end else begin
        if (ena) begin
            ss_units <= ss_units_next;
            ss_tens  <= ss_tens_next;
            // Update minutes only when seconds carry
            if (sec_carry) begin
                mm_units <= mm_units_next;
                mm_tens  <= mm_tens_next;
            end
            // Update hours and pm only when minutes carry
            if (sec_carry && min_carry) begin
                hour_bin <= hour_bin_next;
                pm       <= pm_next;
            end
        end
        // Update output BCD hh, mm, ss every clock cycle for glitch-free output
        hh <= bin_to_bcd_hour(hour_bin);
        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};
    end
end

endmodule