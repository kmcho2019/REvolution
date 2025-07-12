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
    end else if (ena) begin
        if (q == 4'd9) begin
            q <= 4'd0;
            carry <= 1'b1;
        end else begin
            q <= q + 1;
            carry <= 1'b0;
        end
    end else begin
        carry <= 1'b0;
    end
end

endmodule

module TopModule(
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
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

BCD_Counter ones_counter(
  .clk(clk),
  .reset(reset),
  .ena(1'b1),
  .q(ones_q),
  .carry(ones_carry)
);

BCD_Counter tens_counter(
  .clk(clk),
  .reset(reset),
  .ena(ones_carry),
  .q(tens_q),
  .carry(tens_carry)
);

BCD_Counter hundreds_counter(
  .clk(clk),
  .reset(reset),
  .ena(tens_carry),
  .q(hundreds_q),
  .carry(hundreds_carry)
);

BCD_Counter thousands_counter(
  .clk(clk),
  .reset(reset),
  .ena(hundreds_carry),
  .q(thousands_q),
  .carry()
);

endmodule