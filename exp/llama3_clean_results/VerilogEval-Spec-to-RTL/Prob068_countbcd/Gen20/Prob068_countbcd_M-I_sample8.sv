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

wire ones_carry;
wire tens_carry;
wire hundreds_carry;

assign q = {thousands_q, hundreds_q, tens_q, ones_q};
assign ena = {hundreds_carry, tens_carry, ones_carry};

always @(posedge clk) begin
    if (reset) begin
        ones_q <= 4'd0;
        tens_q <= 4'd0;
        hundreds_q <= 4'd0;
        thousands_q <= 4'd0;
    end else begin
        if (ones_q == 4'd9) begin
            ones_q <= 4'd0;
            ones_carry <= 1'b1;
        end else begin
            ones_q <= ones_q + 1;
            ones_carry <= 1'b0;
        end

        if (ones_carry) begin
            if (tens_q == 4'd9) begin
                tens_q <= 4'd0;
                tens_carry <= 1'b1;
            end else begin
                tens_q <= tens_q + 1;
                tens_carry <= 1'b0;
            end
        end else begin
            tens_carry <= 1'b0;
        end

        if (tens_carry) begin
            if (hundreds_q == 4'd9) begin
                hundreds_q <= 4'd0;
                hundreds_carry <= 1'b1;
            end else begin
                hundreds_q <= hundreds_q + 1;
                hundreds_carry <= 1'b0;
            end
        end else begin
            hundreds_carry <= 1'b0;
        end

        if (hundreds_carry) begin
            if (thousands_q == 4'd9) begin
                thousands_q <= 4'd0;
            end else begin
                thousands_q <= thousands_q + 1;
            end
        end
    end
end

endmodule