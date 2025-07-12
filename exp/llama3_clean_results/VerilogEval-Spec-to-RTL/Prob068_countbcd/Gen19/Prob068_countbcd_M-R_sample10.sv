module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones_q;
reg [3:0] tens_q;
reg [3:0] hundreds_q;
reg [3:0] thousands_q;

always @(posedge clk) begin
    if (reset) begin
        ones_q <= 4'd0;
        tens_q <= 4'd0;
        hundreds_q <= 4'd0;
        thousands_q <= 4'd0;
    end else begin
        // Update ones digit
        if (ones_q == 4'd9) begin
            ones_q <= 4'd0;
        end else begin
            ones_q <= ones_q + 1;
        end

        // Update tens digit
        if (ones_q == 4'd0 && ones_q + 1 == 4'd1) begin
            if (tens_q == 4'd9) begin
                tens_q <= 4'd0;
            end else begin
                tens_q <= tens_q + 1;
            end
        end

        // Update hundreds digit
        if (tens_q == 4'd0 && tens_q + 1 == 4'd1 && ones_q == 4'd0) begin
            if (hundreds_q == 4'd9) begin
                hundreds_q <= 4'd0;
            end else begin
                hundreds_q <= hundreds_q + 1;
            end
        end

        // Update thousands digit
        if (hundreds_q == 4'd0 && hundreds_q + 1 == 4'd1 && tens_q == 4'd0 && ones_q == 4'd0) begin
            if (thousands_q == 4'd9) begin
                thousands_q <= 4'd0;
            end else begin
                thousands_q <= thousands_q + 1;
            end
        end
    end
end

assign q = {thousands_q, hundreds_q, tens_q, ones_q};
assign ena[0] = (ones_q == 4'd9);
assign ena[1] = (tens_q == 4'd9 && ones_q == 4'd0);
assign ena[2] = (hundreds_q == 4'd9 && tens_q == 4'd0 && ones_q == 4'd0);

endmodule