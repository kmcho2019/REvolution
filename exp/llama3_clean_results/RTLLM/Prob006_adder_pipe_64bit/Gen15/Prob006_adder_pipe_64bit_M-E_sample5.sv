module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Parameters
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 6;  // 2^6 = 64

// Kogge-Stone adder module
module kogge_stone_adder(
    input   [DATA_WIDTH-1:0]  a,
    input   [DATA_WIDTH-1:0]  b,
    output  [DATA_WIDTH:0]  sum
);
    // Calculate generate and propagate signals
    wire [DATA_WIDTH-1:0] g, p;
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
        end
    endgenerate

    // Calculate carry signals
    wire [DATA_WIDTH-1:0] c;
    genvar j;
    generate
        for (j = 0; j < DATA_WIDTH; j++) begin
            if (j == 0) begin
                assign c[j] = g[j];
            end else begin
                assign c[j] = g[j] | (p[j] & c[j-1]);
            end
        end
    endgenerate

    // Calculate sum bits
    assign sum[DATA_WIDTH:1] = a ^ b ^ c;
    assign sum[0] = c[DATA_WIDTH-1];
endmodule

// Pipeline stages
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] sum_reg;
reg [STG_WIDTH-1:0]  i_en_reg;
reg                 o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        i_en_reg <= {STG_WIDTH{1'b0}};
        o_en_reg <= 1'b0;
        sum_reg <= {DATA_WIDTH+1{1'b0}};
    end else begin
        i_en_reg <= {i_en_reg[0], i_en};
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        if (i_en_reg[STG_WIDTH-1]) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
        kogge_stone_adder ksa(
           .a(adda_reg),
           .b(addb_reg),
           .sum(sum_reg)
        );
    end
end

// Output assignment
assign result = sum_reg;
assign o_en = o_en_reg;

endmodule