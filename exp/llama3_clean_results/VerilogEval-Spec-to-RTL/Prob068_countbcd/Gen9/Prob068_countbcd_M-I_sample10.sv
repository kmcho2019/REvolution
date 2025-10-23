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

assign q = {thousands_q, hundreds_q, tens_q, ones_q};

always @(posedge clk) begin
    if (reset) begin
        ones_q <= 4'd0;
        tens_q <= 4'd0;
        hundreds_q <= 4'd0;
        thousands_q <= 4'd0;
    end else begin
        if (ones_q == 4'd9) begin
            ones_q <= 4'd0;
            if (tens_q == 4'd9) begin
                tens_q <= 4'd0;
                if (hundreds_q == 4'd9) begin
                    hundreds_q <= 4'd0;
                    if (thousands_q == 4'd9) begin
                        thousands_q <= 4'd0;
                    end else begin
                        thousands_q <= thousands_q + 1;
                    end
                end else begin
                    hundreds_q <= hundreds_q + 1;
                end
            end else begin
                tens_q <= tens_q + 1;
            end
        end else begin
            ones_q <= ones_q + 1;
        end
    end
end

assign ena[0] = (ones_q == 4'd9);
assign ena[1] = (tens_q == 4'd9) && (ones_q == 4'd9);
assign ena[2] = (hundreds_q == 4'd9) && (tens_q == 4'd9) && (ones_q == 4'd9);

endmodule