module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units, tens, hundreds;
wire units_tc = (units == 4'd9);
wire tens_tc = (tens == 4'd9);
wire hundreds_tc = (hundreds == 4'd9);
wire terminal_count = units_tc & tens_tc & hundreds_tc;

// Units counter (0-9)
always @(posedge clk) begin
    if (reset) begin
        units <= 4'd0;
    end else begin
        units <= (terminal_count || units_tc) ? 4'd0 : units + 4'd1;
    end
end

// Tens counter (0-9)
always @(posedge clk) begin
    if (reset) begin
        tens <= 4'd0;
    end else if (units_tc) begin
        tens <= (tens_tc) ? 4'd0 : tens + 4'd1;
    end
end

// Hundreds counter (0-9)
always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'd0;
    end else if (units_tc & tens_tc) begin
        hundreds <= (hundreds_tc) ? 4'd0 : hundreds + 4'd1;
    end
end

// Combine digits to form final output
assign q = {hundreds, tens, units} + 6'd0;  // Zero-extend to 10 bits

endmodule