module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] hundreds; // 0 to 9
reg [3:0] tens;     // 0 to 9
reg [3:0] ones;     // 0 to 9

always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'd0;
        tens <= 4'd0;
        ones <= 4'd0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 4'd0;
            if (tens == 4'd9) begin
                tens <= 4'd0;
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0; // Roll over to 0
                end else begin
                    hundreds <= hundreds + 1;
                end
            end else begin
                tens <= tens + 1;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

assign q = {hundreds, tens, ones};

endmodule