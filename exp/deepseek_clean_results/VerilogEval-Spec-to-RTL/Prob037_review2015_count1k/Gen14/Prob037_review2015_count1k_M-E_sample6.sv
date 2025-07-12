module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [3:0] units;   // 0-9
reg [3:0] tens;    // 0-9
reg [3:0] hundreds;// 0-9

always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Units digit counting
        if (units == 4'd9) begin
            units <= 4'd0;
            // Tens digit counting
            if (tens == 4'd9) begin
                tens <= 4'd0;
                // Hundreds digit counting
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end
                else begin
                    hundreds <= hundreds + 1'b1;
                end
            end
            else begin
                tens <= tens + 1'b1;
            end
        end
        else begin
            units <= units + 1'b1;
        end
    end
end

// Combine BCD digits to form 10-bit output
always @(*) begin
    q = {hundreds, tens, units[3:0]};
end

endmodule