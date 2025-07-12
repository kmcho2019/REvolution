module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 4
) (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

reg [DATA_WIDTH-1:0]  adda_reg [STG_WIDTH-1:0];
reg [DATA_WIDTH-1:0]  addb_reg [STG_WIDTH-1:0];
reg [DATA_WIDTH:0]  sum_reg [STG_WIDTH-1:0];
reg                 i_en_reg [STG_WIDTH-1:0];

// Full adder module
module full_adder (
    input   [DATA_WIDTH-1:0]  a,
    input   [DATA_WIDTH-1:0]  b,
    input                   cin,
    output  [DATA_WIDTH-1:0]  sum,
    output                  cout
);
    assign sum = a + b + cin;
    assign cout = (a + b + cin) >= {1'b1, {(DATA_WIDTH-1){1'b0}}};
endmodule

// Pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < STG_WIDTH; i++) begin
            adda_reg[i] <= {DATA_WIDTH{1'b0}};
            addb_reg[i] <= {DATA_WIDTH{1'b0}};
            i_en_reg[i] <= 1'b0;
            if (i < STG_WIDTH-1) begin
                sum_reg[i] <= {DATA_WIDTH+1{1'b0}};
            end
        end
    end else begin
        // First pipeline stage
        if (i_en) begin
            adda_reg[0] <= adda;
            addb_reg[0] <= addb;
            i_en_reg[0] <= 1'b1;
        end
        
        // Subsequent pipeline stages
        for (int i = 1; i < STG_WIDTH; i++) begin
            if (i_en_reg[i-1]) begin
                adda_reg[i] <= adda_reg[i-1];
                addb_reg[i] <= addb_reg[i-1];
                i_en_reg[i] <= 1'b1;
                
                // Ripple carry adder
                if (i == 1) begin
                    full_adder fa (
                        .a(adda_reg[i-1]),
                        .b(addb_reg[i-1]),
                        .cin(1'b0),
                        .sum(sum_reg[i-1][DATA_WIDTH-1:0]),
                        .cout(sum_reg[i-1][DATA_WIDTH])
                    );
                end else begin
                    full_adder fa (
                        .a(adda_reg[i-1]),
                        .b(addb_reg[i-1]),
                        .cin(sum_reg[i-2][DATA_WIDTH]),
                        .sum(sum_reg[i-1][DATA_WIDTH-1:0]),
                        .cout(sum_reg[i-1][DATA_WIDTH])
                    );
                end
            end
        end
    end
end

// Output stage
assign result = sum_reg[STG_WIDTH-2];
assign o_en = i_en_reg[STG_WIDTH-1];

endmodule