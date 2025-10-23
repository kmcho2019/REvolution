module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input  [63:0]       adda,
    input  [63:0]       addb,
    output [64:0]       result,
    output              o_en
);

reg [63:0]             adda_reg;
reg [63:0]             addb_reg;
reg                   i_en_reg;
reg                   i_en_reg2;
reg [64:0]             sum_reg [3:0];
reg [64:0]             result_reg;
reg                   o_en_reg;

assign result = result_reg;
assign o_en   = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg        <= 64'd0;
        addb_reg        <= 64'd0;
        i_en_reg        <= 1'b0;
        i_en_reg2       <= 1'b0;
        sum_reg[0]      <= 65'd0;
        sum_reg[1]      <= 65'd0;
        sum_reg[2]      <= 65'd0;
        sum_reg[3]      <= 65'd0;
        result_reg      <= 65'd0;
        o_en_reg        <= 1'b0;
    end else begin
        adda_reg        <= adda;
        addb_reg        <= addb;
        i_en_reg        <= i_en;
        i_en_reg2       <= i_en_reg;
        
        // Perform addition in four stages
        sum_reg[0]      <= {1'b0, adda_reg[7:0]}  + {1'b0, addb_reg[7:0]};
        sum_reg[1]      <= {sum_reg[0][8], sum_reg[0][7:0]} + {1'b0, adda_reg[15:8]} + {1'b0, addb_reg[15:8]};
        sum_reg[2]      <= {sum_reg[1][8], sum_reg[1][7:0]} + {1'b0, adda_reg[23:16]} + {1'b0, addb_reg[23:16]};
        sum_reg[3]      <= {sum_reg[2][8], sum_reg[2][7:0]} + {1'b0, adda_reg[31:24]} + {1'b0, addb_reg[31:24]};
        result_reg      <= {sum_reg[3][8], sum_reg[3][7:0]} + {1'b0, adda_reg[39:32]} + {1'b0, addb_reg[39:32]} + 
                          {1'b0, adda_reg[47:40]} + {1'b0, addb_reg[47:40]} + 
                          {1'b0, adda_reg[55:48]} + {1'b0, addb_reg[55:48]} + 
                          {1'b0, adda_reg[63:56]} + {1'b0, addb_reg[63:56]};
        o_en_reg        <= i_en_reg2;
    end
end

endmodule