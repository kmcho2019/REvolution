module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [6:0] tens_units;  // Counts 00-99 (7 bits needed for 0-99)
reg [3:0] hundreds;    // Counts 0-9 (4 bits needed for 0-9)

wire tens_units_wrap = (tens_units == 7'd99);
wire hundreds_wrap = (hundreds == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        tens_units <= 7'd0;
        hundreds <= 4'd0;
    end else begin
        if (tens_units_wrap) begin
            tens_units <= 7'd0;
            if (hundreds_wrap) begin
                hundreds <= 4'd0;
            end else begin
                hundreds <= hundreds + 4'd1;
            end
        end else begin
            tens_units <= tens_units + 7'd1;
        end
    end
end

assign q = {hundreds, tens_units[6:0]};

endmodule