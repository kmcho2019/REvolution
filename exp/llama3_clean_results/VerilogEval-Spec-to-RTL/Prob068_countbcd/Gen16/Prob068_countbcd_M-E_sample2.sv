module BCD_ALU(
    input  clk,
    input  reset,
    input  cin,
    output cout,
    output reg q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else if (cin && q) begin
        q <= 1'b0;
        cout <= 1'b1;
    end else if (cin && ~q) begin
        q <= 1'b1;
        cout <= 1'b0;
    end else if (~cin && q) begin
        q <= 1'b0;
        cout <= 1'b0;
    end else begin
        q <= 1'b0;
        cout <= 1'b0;
    end
end

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

wire [3:0] cout_ones;
wire [3:0] cout_tens;
wire [3:0] cout_hundreds;

BCD_ALU ones_bit0(
    .clk(clk),
    .reset(reset),
    .cin(1'b1),
    .cout(cout_ones[0]),
    .q(q[0])
);

BCD_ALU ones_bit1(
    .clk(clk),
    .reset(reset),
    .cin(cout_ones[0]),
    .cout(cout_ones[1]),
    .q(q[1])
);

BCD_ALU ones_bit2(
    .clk(clk),
    .reset(reset),
    .cin(cout_ones[1]),
    .cout(cout_ones[2]),
    .q(q[2])
);

BCD_ALU ones_bit3(
    .clk(clk),
    .reset(reset),
    .cin(cout_ones[2]),
    .cout(cout_ones[3]),
    .q(q[3])
);

BCD_ALU tens_bit0(
    .clk(clk),
    .reset(reset),
    .cin(cout_ones[3]),
    .cout(cout_tens[0]),
    .q(q[4])
);

BCD_ALU tens_bit1(
    .clk(clk),
    .reset(reset),
    .cin(cout_tens[0]),
    .cout(cout_tens[1]),
    .q(q[5])
);

BCD_ALU tens_bit2(
    .clk(clk),
    .reset(reset),
    .cin(cout_tens[1]),
    .cout(cout_tens[2]),
    .q(q[6])
);

BCD_ALU tens_bit3(
    .clk(clk),
    .reset(reset),
    .cin(cout_tens[2]),
    .cout(cout_tens[3]),
    .q(q[7])
);

BCD_ALU hundreds_bit0(
    .clk(clk),
    .reset(reset),
    .cin(cout_tens[3]),
    .cout(cout_hundreds[0]),
    .q(q[8])
);

BCD_ALU hundreds_bit1(
    .clk(clk),
    .reset(reset),
    .cin(cout_hundreds[0]),
    .cout(cout_hundreds[1]),
    .q(q[9])
);

BCD_ALU hundreds_bit2(
    .clk(clk),
    .reset(reset),
    .cin(cout_hundreds[1]),
    .cout(cout_hundreds[2]),
    .q(q[10])
);

BCD_ALU hundreds_bit3(
    .clk(clk),
    .reset(reset),
    .cin(cout_hundreds[2]),
    .cout(cout_hundreds[3]),
    .q(q[11])
);

BCD_ALU thousands_bit0(
    .clk(clk),
    .reset(reset),
    .cin(cout_hundreds[3]),
    .cout(),
    .q(q[12])
);

BCD_ALU thousands_bit1(
    .clk(clk),
    .reset(reset),
    .cin(q[12]),
    .cout(),
    .q(q[13])
);

BCD_ALU thousands_bit2(
    .clk(clk),
    .reset(reset),
    .cin(q[13]),
    .cout(),
    .q(q[14])
);

BCD_ALU thousands_bit3(
    .clk(clk),
    .reset(reset),
    .cin(q[14]),
    .cout(),
    .q(q[15])
);

assign ena[0] = cout_ones[3];
assign ena[1] = cout_tens[3];
assign ena[2] = cout_hundreds[3];

endmodule