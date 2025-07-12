module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Split counter:
    // hundreds: 4 bits (0 to 15)
    // units: 6 bits (0 to 63)
    reg [3:0] hundreds;
    reg [5:0] units;

    // Reset and counting logic
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
            units <= 6'd0;
            q <= 10'd0;
        end else begin
            // Check if next count == 1000 (decimal)
            // 1000 decimal = 15*64 + 40 = (hundreds=15, units=40)
            if (hundreds == 4'd15 && units == 6'd40) begin
                // Wrap around to zero
                hundreds <= 4'd0;
                units <= 6'd0;
                q <= 10'd0;
            end else begin
                // Increment units
                if (units == 6'd63) begin
                    units <= 6'd0;
                    hundreds <= hundreds + 4'd1;
                end else begin
                    units <= units + 6'd1;
                end
                q <= {hundreds, units}; // Concatenate hundreds and units to form 10-bit output
            end
        end
    end

endmodule