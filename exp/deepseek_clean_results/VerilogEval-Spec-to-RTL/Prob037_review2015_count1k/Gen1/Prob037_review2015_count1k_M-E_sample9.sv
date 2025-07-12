module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] hundreds;
reg [3:0] tens;
reg [3:0] units;

always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'b0;
        tens <= 4'b0;
        units <= 4'b0;
    end
    else begin
        if (units == 4'd9) begin
            units <= 4'b0;
            if (tens == 4'd9) begin
                tens <= 4'b0;
                if (hundreds == 4'd9) begin
                    hundreds <= 4'b0;
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

assign q = {hundreds, tens, units[3:0]};

endmodule