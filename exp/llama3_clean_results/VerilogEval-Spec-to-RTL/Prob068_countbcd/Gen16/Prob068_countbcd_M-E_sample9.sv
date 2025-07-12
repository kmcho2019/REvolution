module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [11:0] count; // Internal count variable
reg [3:0] ones;   // Ones place
reg [3:0] tens;   // Tens place
reg [3:0] hundreds; // Hundreds place
reg [3:0] thousands; // Thousands place

always @(posedge clk) begin
    if (reset) begin
        count <= 12'd0;
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        count <= count + 1;
        
        if (count == 12'd9999) begin
            count <= 12'd0;
        end
        
        // Update BCD digits based on the count
        if (count % 10 == 0 && count != 12'd0) begin
            ones <= 4'd0;
            if (count / 10 % 10 == 9) begin
                tens <= 4'd0;
                if (count / 100 % 10 == 9) begin
                    hundreds <= 4'd0;
                    if (count / 1000 == 9) begin
                        thousands <= 4'd0;
                    end else begin
                        thousands <= thousands + 1;
                    end
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

assign q = {thousands, hundreds, tens, ones};
assign ena[0] = (ones == 4'd9) && (count % 10 != 0);
assign ena[1] = (tens == 4'd9) && (count / 10 % 10 != 0);
assign ena[2] = (hundreds == 4'd9) && (count / 100 % 10 != 0);

endmodule