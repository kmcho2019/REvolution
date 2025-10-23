module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [15:0] seg_result [3:0];
reg [15:0] seg_adda [3:0];
reg [15:0] seg_addb [3:0];
reg        carry [3:0];
reg        en;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        en <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        en <= 1'b1;
    end
end

// Segment adders and carry propagation
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 4; i++) begin
            seg_adda[i] <= 16'd0;
            seg_addb[i] <= 16'd0;
            seg_result[i] <= 16'd0;
            carry[i] <= 1'b0;
        end
    end else begin
        seg_adda[0] <= adda_reg[15:0];
        seg_addb[0] <= addb_reg[15:0];
        seg_adda[1] <= adda_reg[31:16];
        seg_addb[1] <= addb_reg[31:16];
        seg_adda[2] <= adda_reg[47:32];
        seg_addb[2] <= addb_reg[47:32];
        seg_adda[3] <= adda_reg[63:48];
        seg_addb[3] <= addb_reg[63:48];

        seg_result[0] <= seg_adda[0] + seg_addb[0];
        carry[0] <= (seg_adda[0] + seg_addb[0]) > 16'd65535;

        seg_result[1] <= seg_adda[1] + seg_addb[1] + carry[0];
        carry[1] <= (seg_adda[1] + seg_addb[1] + carry[0]) > 16'd65535;

        seg_result[2] <= seg_adda[2] + seg_addb[2] + carry[1];
        carry[2] <= (seg_adda[2] + seg_addb[2] + carry[1]) > 16'd65535;

        seg_result[3] <= seg_adda[3] + seg_addb[3] + carry[2];
        carry[3] <= (seg_adda[3] + seg_addb[3] + carry[2]) > 16'd65535;
    end
end

// Output registers
reg [64:0] out_result;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_result <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (en) begin
        out_result <= {carry[3], seg_result[3], seg_result[2], seg_result[1], seg_result[0]};
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = out_result;
assign o_en = o_en_reg;

endmodule