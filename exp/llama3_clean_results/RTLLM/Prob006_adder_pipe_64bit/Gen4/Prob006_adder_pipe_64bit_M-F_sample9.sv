module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [63:0] sum_reg;
reg [63:0] carry_reg;
reg o_en_reg;
reg [63:0] sum_pipeline [3:0];
reg [63:0] carry_pipeline [3:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 0;
        addb_reg <= 0;
        sum_reg <= 0;
        carry_reg <= 0;
        o_en_reg <= 0;
        for (i = 0; i < 4; i++) begin
            sum_pipeline[i] <= 0;
            carry_pipeline[i] <= 0;
        end
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 0;
        for (i = 0; i < 4; i++) begin
            if (i == 0) begin
                sum_pipeline[i] <= adda;
                carry_pipeline[i] <= 0;
            end else begin
                sum_pipeline[i] <= sum_pipeline[i-1];
                carry_pipeline[i] <= carry_pipeline[i-1];
            end
        end
    end else begin
        for (i = 0; i < 4; i++) begin
            if (i == 0) begin
                sum_pipeline[i] <= adda_reg;
                carry_pipeline[i] <= 0;
            end else if (i == 1) begin
                sum_pipeline[i] <= sum_pipeline[i-1] + addb_reg;
                carry_pipeline[i] <= 0;
            end else if (i == 2) begin
                sum_pipeline[i] <= sum_pipeline[i-1];
                carry_pipeline[i] <= carry_pipeline[i-1];
            end else if (i == 3) begin
                sum_pipeline[i] <= sum_pipeline[i-1];
                carry_pipeline[i] <= carry_pipeline[i-1];
                o_en_reg <= 1;
            end
        end
    end
end

reg [64:0] final_sum;

always @(*) begin
    reg [63:0] temp_sum;
    reg [63:0] temp_carry;
    temp_sum = sum_pipeline[3];
    temp_carry = carry_pipeline[3];
    for (int i = 63; i >= 0; i--) begin
        full_adder fa(
           .a(temp_sum[i]),
           .b(addb_reg[i]),
           .cin(temp_carry[i]),
           .sum(final_sum[i]),
           .cout(temp_carry[i-1])
        );
    end
    final_sum[64] = temp_carry[0];
end

assign result = final_sum;
assign o_en = o_en_reg;

endmodule