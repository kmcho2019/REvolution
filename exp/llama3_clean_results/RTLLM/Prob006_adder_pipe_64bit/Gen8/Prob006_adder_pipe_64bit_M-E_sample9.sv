module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Segmenting the input operands into 16-bit segments
reg [15:0] seg1_adda;
reg [15:0] seg1_addb;
reg [15:0] seg2_adda;
reg [15:0] seg2_addb;
reg [15:0] seg3_adda;
reg [15:0] seg3_addb;
reg [15:0] seg4_adda;
reg [15:0] seg4_addb;

// Carry-save adders for each segment
reg [15:0] seg1_sum;
reg [15:0] seg1_cout;
reg [15:0] seg2_sum;
reg [15:0] seg2_cout;
reg [15:0] seg3_sum;
reg [15:0] seg3_cout;
reg [15:0] seg4_sum;
reg [15:0] seg4_cout;

// Carry-lookahead adders for each segment
reg [15:0] seg1_final_sum;
reg [15:0] seg2_final_sum;
reg [15:0] seg3_final_sum;
reg [15:0] seg4_final_sum;
reg [1:0] seg1_final_cout;
reg [1:0] seg2_final_cout;
reg [1:0] seg3_final_cout;
reg [1:0] seg4_final_cout;

// Combining the results from each segment
reg [64:0] result_reg;

// Output enable signal generation
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        seg1_adda <= 16'd0;
        seg1_addb <= 16'd0;
        seg2_adda <= 16'd0;
        seg2_addb <= 16'd0;
        seg3_adda <= 16'd0;
        seg3_addb <= 16'd0;
        seg4_adda <= 16'd0;
        seg4_addb <= 16'd0;
        seg1_sum <= 16'd0;
        seg1_cout <= 16'd0;
        seg2_sum <= 16'd0;
        seg2_cout <= 16'd0;
        seg3_sum <= 16'd0;
        seg3_cout <= 16'd0;
        seg4_sum <= 16'd0;
        seg4_cout <= 16'd0;
        seg1_final_sum <= 16'd0;
        seg2_final_sum <= 16'd0;
        seg3_final_sum <= 16'd0;
        seg4_final_sum <= 16'd0;
        seg1_final_cout <= 2'd0;
        seg2_final_cout <= 2'd0;
        seg3_final_cout <= 2'd0;
        seg4_final_cout <= 2'd0;
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        // Segmenting the input operands into 16-bit segments
        seg1_adda <= adda[15:0];
        seg1_addb <= addb[15:0];
        seg2_adda <= adda[31:16];
        seg2_addb <= addb[31:16];
        seg3_adda <= adda[47:32];
        seg3_addb <= addb[47:32];
        seg4_adda <= adda[63:48];
        seg4_addb <= addb[63:48];

        // Carry-save adders for each segment
        {seg1_sum, seg1_cout} <= seg1_adda + seg1_addb;
        {seg2_sum, seg2_cout} <= seg2_adda + seg2_addb;
        {seg3_sum, seg3_cout} <= seg3_adda + seg3_addb;
        {seg4_sum, seg4_cout} <= seg4_adda + seg4_addb;

        // Carry-lookahead adders for each segment
        {seg1_final_sum, seg1_final_cout} <= {seg1_sum, seg1_cout};
        {seg2_final_sum, seg2_final_cout} <= {seg2_sum, seg2_cout};
        {seg3_final_sum, seg3_final_cout} <= {seg3_sum, seg3_cout};
        {seg4_final_sum, seg4_final_cout} <= {seg4_sum, seg4_cout};

        // Combining the results from each segment
        result_reg <= {seg4_final_cout, seg4_final_sum, seg3_final_sum, seg2_final_sum, seg1_final_sum};

        // Output enable signal generation
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule