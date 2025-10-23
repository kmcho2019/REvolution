module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 3
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

// Internal signals
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [STG_WIDTH-1:0] i_en_reg;
reg [DATA_WIDTH:0] sum_reg;

// Stage 1: Register input operands
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Stage 2: Calculate sum using Kogge-Stone Adder
reg [DATA_WIDTH:0] sum_int;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_int <= {DATA_WIDTH+1{1'b0}};
    end else begin
        // Kogge-Stone Adder implementation
        sum_int[0] = adda_reg[0] ^ addb_reg[0];
        for (int i = 1; i < DATA_WIDTH; i++) begin
            sum_int[i] = adda_reg[i] ^ addb_reg[i] ^ (sum_int[i-1] & (adda_reg[i-1] | addb_reg[i-1]));
        end
        sum_int[DATA_WIDTH] = (sum_int[DATA_WIDTH-1] & (adda_reg[DATA_WIDTH-1] | addb_reg[DATA_WIDTH-1]));
    end
end

// Stage 3: Register sum and manage o_en
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {DATA_WIDTH+1{1'b0}};
        i_en_reg <= {STG_WIDTH{1'b0}};
        o_en <= 1'b0;
    end else begin
        i_en_reg <= {i_en_reg[STG_WIDTH-2:0], i_en};
        sum_reg <= sum_int;
        if (i_en_reg[STG_WIDTH-1]) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

// Assign result
assign result = sum_reg;

endmodule

// Example testbench to verify the module's functionality
module tb_adder_pipe_64bit;
    reg clk;
    reg rst_n;
    reg i_en;
    reg [63:0] adda;
    reg [63:0] addb;
    wire [64:0] result;
    wire o_en;

    adder_pipe_64bit #(
        .DATA_WIDTH(64),
        .STG_WIDTH(3)
    ) u_pip_add64(
       .clk(clk),
       .rst_n(rst_n),
       .i_en(i_en),
       .adda(adda),
       .addb(addb),
       .result(result),
       .o_en(o_en)
    );

    initial begin
        clk = 0;
        rst_n = 1'b0;
        i_en = 1'b0;
        adda = 64'd0;
        addb = 64'd0;
        #10;
        rst_n = 1'b1;
        #10;
        i_en = 1'b1;
        adda = 64'd10;
        addb = 64'd20;
        #20;
        $finish;
    end

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule