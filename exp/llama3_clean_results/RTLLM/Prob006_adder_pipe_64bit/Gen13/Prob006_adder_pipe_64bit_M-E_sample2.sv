module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the number of processing elements (PEs)
localparam NUM_PEs = 8;

// Define the width of each PE
localparam PE_WIDTH = 8;

// Define the pipeline stages
localparam NUM_STAGES = 3;

// Define the registers for the pipeline stages
reg [PE_WIDTH-1:0] adda_reg [0:NUM_PEs-1];
reg [PE_WIDTH-1:0] addb_reg [0:NUM_PEs-1];
reg [PE_WIDTH:0] sum_reg [0:NUM_PEs-1];
reg [PE_WIDTH:0] carry_reg [0:NUM_PEs-1];

// Define the registers for the output pipeline stage
reg [64:0] result_reg;
reg o_en_reg;

// Segment the input operands into 8-bit chunks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < NUM_PEs; i++) begin
            adda_reg[i] <= 8'd0;
            addb_reg[i] <= 8'd0;
        end
    end else if (i_en) begin
        for (int i = 0; i < NUM_PEs; i++) begin
            adda_reg[i] <= adda[(i*PE_WIDTH)+:PE_WIDTH];
            addb_reg[i] <= addb[(i*PE_WIDTH)+:PE_WIDTH];
        end
    end
end

// Perform the addition operation in parallel across all PEs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < NUM_PEs; i++) begin
            sum_reg[i] <= 9'd0;
            carry_reg[i] <= 1'd0;
        end
    end else if (i_en) begin
        sum_reg[0] <= adda_reg[0] + addb_reg[0];
        carry_reg[0] <= (adda_reg[0][7] & addb_reg[0][7]) | ((adda_reg[0][7:1] + addb_reg[0][7:1]) >= 8'd1);
        for (int i = 1; i < NUM_PEs; i++) begin
            sum_reg[i] <= adda_reg[i] + addb_reg[i] + carry_reg[i-1][0];
            carry_reg[i] <= (adda_reg[i][7] & addb_reg[i][7]) | ((adda_reg[i][7:1] + addb_reg[i][7:1] + carry_reg[i-1][0]) >= 8'd1);
        end
    end
end

// Combine the results to form the final 65-bit output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        result_reg <= {1'b0, sum_reg[7][7:0], sum_reg[6][7:0], sum_reg[5][7:0], sum_reg[4][7:0], sum_reg[3][7:0], sum_reg[2][7:0], sum_reg[1][7:0], sum_reg[0][7:0]};
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule