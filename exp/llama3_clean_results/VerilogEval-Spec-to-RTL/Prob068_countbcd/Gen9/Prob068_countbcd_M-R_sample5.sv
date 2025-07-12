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

assign ena = {hundreds_carry, tens_carry, ones_carry};

BCD_Counter ones_counter(
  .clk(clk),
  .reset(reset),
  .ena(1'b1),
  .q(ones_count),
  .carry(ones_carry)
);

BCD_Counter tens_counter(
  .clk(clk),
  .reset(reset),
  .ena(ones_carry),
  .q(tens_count),
  .carry(tens_carry)
);

BCD_Counter hundreds_counter(
  .clk(clk),
  .reset(reset),
  .ena(tens_carry),
  .q(hundreds_count),
  .carry(hundreds_carry)
);

BCD_Counter thousands_counter(
  .clk(clk),
  .reset(reset),
  .ena(hundreds_carry),
  .q(thousands_count),
  .carry()
);

assign q = {thousands_count, hundreds_count, tens_count, ones_count};

endmodule