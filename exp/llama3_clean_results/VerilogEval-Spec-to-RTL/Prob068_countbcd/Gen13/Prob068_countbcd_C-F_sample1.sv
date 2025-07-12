module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output carry
);

reg [3:0] count;
reg clk_enable;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
        clk_enable <= 1'b0;
    end else if (ena) begin
        clk_enable <= 1'b1;
        count <= (count == 4'd9)? 4'd0 : count + 1;
    end else begin
        clk_enable <= 1'b0;
    end
end

assign q = count;
assign carry = (count == 4'd9) && ena;

// Clock gating
assign clk_gated = clk_enable? clk : 1'b0;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

wire ones_carry;
wire tens_carry;
wire hundreds_carry;

assign ena = {hundreds_carry, tens_carry, ones_carry};

BCD_Counter ones_counter(
 .clk(clk),
 .reset(reset),
 .ena(1'b1),
 .q(q[3:0]),
 .carry(ones_carry)
);

BCD_Counter tens_counter(
 .clk(clk),
 .reset(reset),
 .ena(ones_carry),
 .q(q[7:4]),
 .carry(tens_carry)
);

BCD_Counter hundreds_counter(
 .clk(clk),
 .reset(reset),
 .ena(tens_carry),
 .q(q[11:8]),
 .carry(hundreds_carry)
);

BCD_Counter thousands_counter(
 .clk(clk),
 .reset(reset),
 .ena(hundreds_carry),
 .q(q[15:12]),
 .carry()
);

endmodule