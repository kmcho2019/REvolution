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
reg [STG_WIDTH-1:0] adda_regs [NUM_STAGES-1:0];
reg [STG_WIDTH-1:0] addb_regs [NUM_STAGES-1:0];
reg [STG_WIDTH:0] partial_sums [NUM_STAGES-1:0];
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            adda_regs[i] <= {STG_WIDTH{1'b0}};
            addb_regs[i] <= {STG_WIDTH{1'b0}};
        end
    end else if (i_en) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            adda_regs[i] <= adda[(i*STG_WIDTH)+:STG_WIDTH];
            addb_regs[i] <= addb[(i*STG_WIDTH)+:STG_WIDTH];
        end
    end
end

// Pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            partial_sums[i] <= {STG_WIDTH+1{1'b0}};
        end
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            if (i == 0) begin
                partial_sums[i] <= {1'b0, adda_regs[i]} + {1'b0, addb_regs[i]};
            end else begin
                partial_sums[i] <= {partial_sums[i-1][STG_WIDTH], adda_regs[i]} + {partial_sums[i-1][STG_WIDTH], addb_regs[i]};
            end
        end
        result_reg <= {partial_sums[NUM_STAGES-1][STG_WIDTH], partial_sums[NUM_STAGES-1][STG_WIDTH-1:0]};
        o_en_reg <= (partial_sums[NUM_STAGES-1][STG_WIDTH] == 1'b1);
    end
end

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else begin
        result <= result_reg;
        o_en <= o_en_reg;
    end
end

endmodule