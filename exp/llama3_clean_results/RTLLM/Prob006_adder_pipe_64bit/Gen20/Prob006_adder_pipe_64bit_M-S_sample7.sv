module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

// Calculate the number of stages
parameter NUM_STAGES = DATA_WIDTH / STG_WIDTH;

// Define wires and registers
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
    end else if (i_en) begin
        reg [DATA_WIDTH:0] temp_result;
        temp_result[STG_WIDTH-1:0] = adda_reg[STG_WIDTH-1:0] + addb_reg[STG_WIDTH-1:0];
        for (int i = 1; i < NUM_STAGES; i++) begin
            temp_result[(i*STG_WIDTH)+STG_WIDTH-1:(i*STG_WIDTH)] = adda_reg[(i*STG_WIDTH)+STG_WIDTH-1:(i*STG_WIDTH)] + addb_reg[(i*STG_WIDTH)+STG_WIDTH-1:(i*STG_WIDTH)] + temp_result[(i-1)*STG_WIDTH+STG_WIDTH-1];
        end
        result_reg <= {temp_result[DATA_WIDTH-1], temp_result[DATA_WIDTH-1:0]};
    end
end

// Output assignment
assign result = result_reg;
assign o_en = o_en_reg;

endmodule