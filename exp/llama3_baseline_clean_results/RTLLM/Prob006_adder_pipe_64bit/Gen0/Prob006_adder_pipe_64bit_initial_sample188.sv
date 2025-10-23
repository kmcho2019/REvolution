module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg [63:0] adda_reg2;
reg [63:0] addb_reg2;
reg i_en_reg1;
reg i_en_reg2;
reg [64:0] sum;
reg [64:0] result_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg1 <= 1'b0;
        i_en_reg2 <= 1'b0;
        sum <= 65'd0;
        result_reg <= 65'd0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        
        // Ripple carry adder
        sum[0] <= adda_reg2[0] ^ addb_reg2[0];
        for (genvar i = 1; i < 64; i++) begin
            sum[i] <= adda_reg2[i] ^ addb_reg2[i] ^ sum[i-1];
        end
        sum[64] <= sum[63];
        
        // Update result and output enable
        result_reg <= {1'b0, adda_reg2} + {1'b0, addb_reg2};
        if (i_en_reg2)
            o_en <= 1'b1;
        else
            o_en <= 1'b0;
    end
end

assign result = result_reg;

endmodule