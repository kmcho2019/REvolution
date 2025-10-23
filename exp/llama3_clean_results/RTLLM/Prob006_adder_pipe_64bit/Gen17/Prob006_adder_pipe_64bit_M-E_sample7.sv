module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define parameters
parameter NUM_STAGES = 8;

// Define wires and registers
reg [7:0] adda_regs [NUM_STAGES-1:0];
reg [7:0] addb_regs [NUM_STAGES-1:0];
reg [8:0] partial_sums [NUM_STAGES-1:0];
reg [64:0] result_reg;
reg o_en_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            adda_regs[i] <= 8'd0;
            addb_regs[i] <= 8'd0;
        end
    end else if (i_en) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            adda_regs[i] <= adda[(i*8)+:8];
            addb_regs[i] <= addb[(i*8)+:8];
        end
    end
end

// Pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            partial_sums[i] <= 9'd0;
        end
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            if (i == 0) begin
                partial_sums[i] <= {1'b0, adda_regs[i]} + {1'b0, addb_regs[i]};
            end else begin
                partial_sums[i] <= {partial_sums[i-1][8], adda_regs[i]} + {partial_sums[i-1][8], addb_regs[i]};
            end
        end
        result_reg <= {partial_sums[NUM_STAGES-1][8], partial_sums[NUM_STAGES-1][7:0]};
        o_en_reg <= (partial_sums[NUM_STAGES-1][8] == 1'b1);
    end
end

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        result <= result_reg;
        o_en <= o_en_reg;
    end
end

endmodule