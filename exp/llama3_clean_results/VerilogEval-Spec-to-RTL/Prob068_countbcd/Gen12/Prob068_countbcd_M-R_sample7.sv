module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output reg [3:0] q,
    output reg carry
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
        carry <= 1'b0;
    end else if (ena) begin
        if (q == 4'd9) begin
            q <= 4'd0;
            carry <= 1'b1;
        end else begin
            q <= q + 1;
            carry <= 1'b0;
        end
    end
end

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

assign ena[0] = ones_carry;
assign ena[1] = tens_carry;
assign ena[2] = hundreds_carry;

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