module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output reg carry
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
            carry <= 1'b1;
        end else begin
            count <= count + 1;
            carry <= 1'b0;
        end
    end else begin
        carry <= 1'b0;
    end
end

assign q = count;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

wire [3:0] ones_q;
wire [3:0] tens_q;
wire [3:0] hundreds_q;
wire [3:0] thousands_q;

wire ones_carry;
wire tens_carry;
wire hundreds_carry;

assign q = {thousands_q, hundreds_q, tens_q, ones_q};
assign ena[0] = ones_carry;
assign ena[1] = tens_carry;
assign ena[2] = hundreds_carry;

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