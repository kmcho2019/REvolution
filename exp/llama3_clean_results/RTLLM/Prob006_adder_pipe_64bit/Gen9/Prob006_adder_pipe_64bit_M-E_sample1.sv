// Full adder module
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

// 64-bit ripple carry adder with pipeline stages
module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Pipeline stages
reg [DATA_WIDTH:0] sum_reg;
reg [DATA_WIDTH-1:0] cout_reg;
integer i;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {DATA_WIDTH+1{1'b0}};
        cout_reg <= {DATA_WIDTH{1'b0}};
    end else if (i_en) begin
        sum_reg <= {1'b0, adda_reg} + {1'b0, addb_reg};
        cout_reg <= {DATA_WIDTH{1'b0}};
        for (i = 0; i < DATA_WIDTH; i++) begin
            full_adder fa(
                .a(adda_reg[i]),
                .b(addb_reg[i]),
                .cin(i == 0 ? 1'b0 : cout_reg[i-1]),
                .sum(sum_reg[i]),
                .cout(cout_reg[i])
            );
        end
    end
end

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        result_reg <= sum_reg;
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule