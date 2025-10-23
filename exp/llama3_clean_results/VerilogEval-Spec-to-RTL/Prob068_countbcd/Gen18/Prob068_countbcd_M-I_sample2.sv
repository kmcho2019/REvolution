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

module UnifiedBCDCounter(
    input  clk,
    input  reset,
    output [15:0] q,
    output [2:0] ena
);

wire ones_carry;
wire tens_carry;
wire hundreds_carry;

assign ena[0] = ones_carry;
assign ena[1] = tens_carry;
assign ena[2] = hundreds_carry;

// Using clock gating to reduce power consumption
reg clk_gated_ones;
reg clk_gated_tens;
reg clk_gated_hundreds;
reg clk_gated_thousands;

always @(posedge clk) begin
    if (reset) begin
        clk_gated_ones <= 1'b0;
        clk_gated_tens <= 1'b0;
        clk_gated_hundreds <= 1'b0;
        clk_gated_thousands <= 1'b0;
    end else begin
        clk_gated_ones <= 1'b1;
        if (~ones_carry) begin
            clk_gated_tens <= 1'b0;
        end else begin
            clk_gated_tens <= 1'b1;
        end
        if (~tens_carry) begin
            clk_gated_hundreds <= 1'b0;
        end else begin
            clk_gated_hundreds <= 1'b1;
        end
        if (~hundreds_carry) begin
            clk_gated_thousands <= 1'b0;
        end else begin
            clk_gated_thousands <= 1'b1;
        end
    end
end

BCD_Counter ones_counter(
   .clk(clk),
   .reset(reset),
   .ena(clk_gated_ones),
   .q(q[3:0]),
   .carry(ones_carry)
);

BCD_Counter tens_counter(
   .clk(clk),
   .reset(reset),
   .ena(clk_gated_tens),
   .q(q[7:4]),
   .carry(tens_carry)
);

BCD_Counter hundreds_counter(
   .clk(clk),
   .reset(reset),
   .ena(clk_gated_hundreds),
   .q(q[11:8]),
   .carry(hundreds_carry)
);

BCD_Counter thousands_counter(
   .clk(clk),
   .reset(reset),
   .ena(clk_gated_thousands),
   .q(q[15:12]),
   .carry()
);

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

UnifiedBCDCounter counter(
   .clk(clk),
   .reset(reset),
   .q(q),
   .ena(ena)
);

endmodule