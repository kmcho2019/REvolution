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
reg [1:0]  i_en_reg;
reg [64:0] sum_reg;

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 2'b00;
        o_en <= 1'b0;
        sum_reg <= 65'd0;
    end else begin
        i_en_reg <= {i_en_reg[0], i_en};
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        if (i_en_reg[1]) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
        if (i_en) begin
            reg [64:0] sum_int;
            sum_int[0] = adda_reg[0] ^ addb_reg[0];
            for (int i = 1; i < 64; i++) begin
                sum_int[i] = adda_reg[i] ^ addb_reg[i] ^ (sum_int[i-1] & (adda_reg[i-1] | addb_reg[i-1]));
            end
            sum_int[64] = (sum_int[63] & (adda_reg[63] | addb_reg[63]));
            sum_reg <= sum_int;
        end
    end
end

// Assign result
assign result = sum_reg;

endmodule