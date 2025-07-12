module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [7:0]  adda_reg [7:0];
reg [7:0]  addb_reg [7:0];
reg [8:0]  sum_reg [7:0];
reg [7:0]  carry_reg;
reg         o_en_reg;

integer i;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 8; i++) begin
            adda_reg[i] <= 8'd0;
            addb_reg[i] <= 8'd0;
            sum_reg[i] <= 9'd0;
        end
        carry_reg <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            // Load input operands into registers
            for (i = 0; i < 8; i++) begin
                adda_reg[i] <= adda[(i*8)+:8];
                addb_reg[i] <= addb[(i*8)+:8];
            end

            // Perform addition and propagate carry
            for (i = 0; i < 8; i++) begin
                if (i == 0) begin
                    sum_reg[i] <= {1'b0, adda_reg[i]} + {1'b0, addb_reg[i]};
                end else begin
                    sum_reg[i] <= {1'b0, adda_reg[i]} + {1'b0, addb_reg[i]} + {8'b0, carry_reg};
                end
                carry_reg <= sum_reg[i][8];
            end

            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = {carry_reg, sum_reg[7][7:0], sum_reg[6][7:0], sum_reg[5][7:0], sum_reg[4][7:0], sum_reg[3][7:0], sum_reg[2][7:0], sum_reg[1][7:0], sum_reg[0][7:0]};
assign o_en = o_en_reg;

endmodule