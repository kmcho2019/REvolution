module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Split counter implementation
reg [2:0] hundreds;  // 0-9 (3 bits)
reg [6:0] tens_units; // 0-99 (7 bits)

// Terminal count detection
wire tc_tens_units = (tens_units == 7'd99);
wire tc_hundreds = (hundreds == 3'd9);
wire terminal_count = tc_hundreds & tc_tens_units;

always @(posedge clk) begin
    if (reset) begin
        hundreds <= 3'd0;
        tens_units <= 7'd0;
    end
    else if (terminal_count) begin
        hundreds <= 3'd0;
        tens_units <= 7'd0;
    end
    else begin
        if (tc_tens_units) begin
            hundreds <= hundreds + 1'b1;
            tens_units <= 7'd0;
        end
        else begin
            tens_units <= tens_units + 1'b1;
        end
    end
end

// Combine outputs
always @(*) begin
    q = {hundreds, tens_units};
end

endmodule