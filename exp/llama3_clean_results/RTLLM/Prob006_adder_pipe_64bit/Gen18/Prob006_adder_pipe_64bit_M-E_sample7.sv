module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8
) (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

localparam PIPELINE_DEPTH = DATA_WIDTH / STG_WIDTH;
localparam NUM_STAGES = $clog2(DATA_WIDTH / STG_WIDTH) + 1;

reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Tree-based adder
reg [DATA_WIDTH:0] sum_reg [NUM_STAGES-1:0];
reg [DATA_WIDTH/STG_WIDTH-1:0] carry_reg [NUM_STAGES-1:0];

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            sum_reg[i] <= {DATA_WIDTH+1{1'b0}};
            carry_reg[i] <= {DATA_WIDTH/STG_WIDTH{1'b0}};
        end
    end else begin
        // Stage 1
        sum_reg[0] <= adda_reg[STG_WIDTH-1:0] + addb_reg[STG_WIDTH-1:0];
        carry_reg[0] <= (adda_reg[STG_WIDTH-1:0] + addb_reg[STG_WIDTH-1:0]) >> STG_WIDTH;
        
        // Subsequent stages
        for (int i = 1; i < NUM_STAGES; i++) begin
            sum_reg[i] <= sum_reg[i-1][STG_WIDTH-1:0] + carry_reg[i-1][STG_WIDTH-1:0] + adda_reg[(i*STG_WIDTH)-1:(i-1)*STG_WIDTH] + addb_reg[(i*STG_WIDTH)-1:(i-1)*STG_WIDTH];
            carry_reg[i] <= (sum_reg[i-1][STG_WIDTH-1:0] + carry_reg[i-1][STG_WIDTH-1:0] + adda_reg[(i*STG_WIDTH)-1:(i-1)*STG_WIDTH] + addb_reg[(i*STG_WIDTH)-1:(i-1)*STG_WIDTH]) >> STG_WIDTH;
        end
    end
end

// Output enable logic
reg [PIPELINE_DEPTH-1:0] o_en_shift;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_shift <= {PIPELINE_DEPTH{1'b0}};
    end else begin
        o_en_shift <= {i_en, o_en_shift[PIPELINE_DEPTH-2:0]};
    end
end

assign o_en = o_en_shift[PIPELINE_DEPTH-1] && (sum_reg[NUM_STAGES-1][DATA_WIDTH:DATA_WIDTH-STG_WIDTH+1] == carry_reg[NUM_STAGES-1]);

// Result register
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
    end else if (o_en) begin
        result_reg <= {carry_reg[NUM_STAGES-1], sum_reg[NUM_STAGES-1][DATA_WIDTH-STG_WIDTH:0]};
    end
end

assign result = result_reg;

endmodule