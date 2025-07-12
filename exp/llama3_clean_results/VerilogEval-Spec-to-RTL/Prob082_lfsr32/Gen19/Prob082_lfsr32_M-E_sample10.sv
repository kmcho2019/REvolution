module LFSR_Cell(
    input  clk,
    input  reset,
    input  tap,
    input  next_bit,
    output reg q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 1'b1; // Reset to 1
    end else if (tap) begin
        q <= next_bit; // Apply tap
    end else begin
        q <= next_bit; // Shift right
    end
end

endmodule

module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

wire [31:1] lfsr_output;
wire [30:0] lfsr_next;

assign lfsr_output[31] = q[31];
assign lfsr_output[21] = q[21];
assign lfsr_output[1] = q[1];
assign lfsr_output[0] = q[0];

assign lfsr_next[0] = q[0] ^ q[21] ^ q[1] ^ q[31];
assign lfsr_next[30:1] = q[29:0]; // Shift right

LFSR_Cell cell_31 (
   .clk(clk),
   .reset(reset),
   .tap(1'b1),
   .next_bit(lfsr_next[31]),
   .q(q[31])
);

LFSR_Cell cell_30 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[30]),
   .q(q[30])
);

LFSR_Cell cell_29 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[29]),
   .q(q[29])
);

LFSR_Cell cell_28 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[28]),
   .q(q[28])
);

LFSR_Cell cell_27 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[27]),
   .q(q[27])
);

LFSR_Cell cell_26 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[26]),
   .q(q[26])
);

LFSR_Cell cell_25 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[25]),
   .q(q[25])
);

LFSR_Cell cell_24 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[24]),
   .q(q[24])
);

LFSR_Cell cell_23 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[23]),
   .q(q[23])
);

LFSR_Cell cell_22 (
   .clk(clk),
   .reset(reset),
   .tap(1'b1),
   .next_bit(lfsr_next[22]),
   .q(q[22])
);

LFSR_Cell cell_21 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[21]),
   .q(q[21])
);

LFSR_Cell cell_20 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[20]),
   .q(q[20])
);

LFSR_Cell cell_19 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[19]),
   .q(q[19])
);

LFSR_Cell cell_18 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[18]),
   .q(q[18])
);

LFSR_Cell cell_17 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[17]),
   .q(q[17])
);

LFSR_Cell cell_16 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[16]),
   .q(q[16])
);

LFSR_Cell cell_15 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[15]),
   .q(q[15])
);

LFSR_Cell cell_14 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[14]),
   .q(q[14])
);

LFSR_Cell cell_13 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[13]),
   .q(q[13])
);

LFSR_Cell cell_12 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[12]),
   .q(q[12])
);

LFSR_Cell cell_11 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[11]),
   .q(q[11])
);

LFSR_Cell cell_10 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[10]),
   .q(q[10])
);

LFSR_Cell cell_9 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[9]),
   .q(q[9])
);

LFSR_Cell cell_8 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[8]),
   .q(q[8])
);

LFSR_Cell cell_7 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[7]),
   .q(q[7])
);

LFSR_Cell cell_6 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[6]),
   .q(q[6])
);

LFSR_Cell cell_5 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[5]),
   .q(q[5])
);

LFSR_Cell cell_4 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[4]),
   .q(q[4])
);

LFSR_Cell cell_3 (
   .clk(clk),
   .reset(reset),
   .tap(1'b0),
   .next_bit(lfsr_next[3]),
   .q(q[3])
);

LFSR_Cell cell_2 (
   .clk(clk),
   .reset(reset),
   .tap(1'b1),
   .next_bit(lfsr_next[2]),
   .q(q[2])
);

LFSR_Cell cell_1 (
   .clk(clk),
   .reset(reset),
   .tap(1'b1),
   .next_bit(lfsr_next[1]),
   .q(q[1])
);

LFSR_Cell cell_0 (
   .clk(clk),
   .reset(reset),
   .tap(1'b1),
   .next_bit(lfsr_next[0]),
   .q(q[0])
);

endmodule