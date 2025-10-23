module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

parameter DATA_WIDTH = 16;
parameter STG_WIDTH = 4;

// Segmenting the input operands into 16-bit segments
reg [15:0] seg1_adda;
reg [15:0] seg1_addb;
reg [15:0] seg2_adda;
reg [15:0] seg2_addb;
reg [15:0] seg3_adda;
reg [15:0] seg3_addb;
reg [15:0] seg4_adda;
reg [15:0] seg4_addb;

// Carry and sum for each segment
reg [15:0] seg1_sum;
reg seg1_cout;
reg [15:0] seg2_sum;
reg seg2_cout;
reg [15:0] seg3_sum;
reg seg3_cout;
reg [15:0] seg4_sum;
reg seg4_cout;

// Output enable signal generation
reg i_en_reg;
reg i_en_reg2;

// Assignments for segmentation
assign seg1_adda = adda[15:0];
assign seg1_addb = addb[15:0];
assign seg2_adda = adda[31:16];
assign seg2_addb = addb[31:16];
assign seg3_adda = adda[47:32];
assign seg3_addb = addb[47:32];
assign seg4_adda = adda[63:48];
assign seg4_addb = addb[63:48];

// Carry and sum calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        seg1_sum <= 16'd0;
        seg1_cout <= 1'd0;
        seg2_sum <= 16'd0;
        seg2_cout <= 1'd0;
        seg3_sum <= 16'd0;
        seg3_cout <= 1'd0;
        seg4_sum <= 16'd0;
        seg4_cout <= 1'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        {seg1_cout, seg1_sum} <= seg1_adda + seg1_addb;
        {seg2_cout, seg2_sum} <= seg2_adda + seg2_addb + seg1_cout;
        {seg3_cout, seg3_sum} <= seg3_adda + seg3_addb + seg2_cout;
        {seg4_cout, seg4_sum} <= seg4_adda + seg4_addb + seg3_cout;
        i_en_reg <= 1'b1;
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
        i_en_reg2 <= 1'b0;
    end else begin
        if (i_en_reg) begin
            result <= {seg4_cout, seg4_sum, seg3_sum, seg2_sum, seg1_sum};
            i_en_reg2 <= 1'b1;
        end
        if (i_en_reg2) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule