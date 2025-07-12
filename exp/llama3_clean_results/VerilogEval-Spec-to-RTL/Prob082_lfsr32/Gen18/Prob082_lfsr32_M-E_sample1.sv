module LFSR_Segment(
    input  clk,
    input  reset,
    input  [31:0] in_data,
    input  [3:0] tap_inputs,
    output reg [31:0] out_data
);

always @(posedge clk) begin
    if (reset) begin
        out_data <= 32'h1;
    end else begin
        out_data <= {in_data[30:0], (in_data[31] ^ tap_inputs[0])};
    end
end

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

wire [31:0] seg1_out;
wire [31:0] seg2_out;
wire [31:0] seg3_out;

LFSR_Segment seg1 (
    .clk(clk),
    .reset(reset),
    .in_data(32'h0),
    .tap_inputs({1'b0, 1'b0, 1'b0, q[0]}),
    .out_data(seg1_out)
);

LFSR_Segment seg2 (
    .clk(clk),
    .reset(reset),
    .in_data(seg1_out),
    .tap_inputs({1'b0, q[21], q[1], q[0]}),
    .out_data(seg2_out)
);

LFSR_Segment seg3 (
    .clk(clk),
    .reset(reset),
    .in_data(seg2_out),
    .tap_inputs({q[31], q[21], q[1], q[0]}),
    .out_data(seg3_out)
);

assign q = seg3_out;

endmodule