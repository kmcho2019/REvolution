module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output carry
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;
assign carry = (count == 4'd9) && ena;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones_count;
reg [3:0] tens_count;
reg [3:0] hundreds_count;
reg [3:0] thousands_count;

wire ones_carry;
wire tens_carry;
wire hundreds_carry;

assign q = {thousands_count, hundreds_count, tens_count, ones_count};
assign ena[0] = ones_carry;
assign ena[1] = tens_carry;
assign ena[2] = hundreds_carry;

assign ones_carry = (ones_count == 4'd9) && (clk && !reset);
assign tens_carry = (tens_count == 4'd9) && (clk && !reset) && ones_carry;
assign hundreds_carry = (hundreds_count == 4'd9) && (clk && !reset) && tens_carry;

always @(posedge clk) begin
    if (reset) begin
        ones_count <= 4'd0;
        tens_count <= 4'd0;
        hundreds_count <= 4'd0;
        thousands_count <= 4'd0;
    end else begin
        if (ones_carry) begin
            ones_count <= 4'd0;
            if (tens_carry) begin
                tens_count <= 4'd0;
                if (hundreds_carry) begin
                    hundreds_count <= 4'd0;
                    thousands_count <= thousands_count + 1;
                    if (thousands_count == 4'd9) begin
                        thousands_count <= 4'd0;
                    end
                end else begin
                    hundreds_count <= hundreds_count + 1;
                end
            end else begin
                tens_count <= tens_count + 1;
            end
        end else begin
            ones_count <= ones_count + 1;
        end
    end
end

endmodule