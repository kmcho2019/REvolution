module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

parameter DATA_WIDTH = 64;
parameter NUM_STAGES = 2;

// Internal registers to hold input operands
reg [DATA_WIDTH-1:0] reg_adda;
reg [DATA_WIDTH-1:0] reg_addb;

// Internal registers for pipelining
reg [DATA_WIDTH-1:0] reg_pipeline [NUM_STAGES-1:0];

// Internal register to hold the result
reg [DATA_WIDTH:0] reg_result;

// Internal register to hold the output enable signal
reg reg_o_en;

// Reset logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= {DATA_WIDTH{1'b0}};
        reg_addb <= {DATA_WIDTH{1'b0}};
        for (int i = 0; i < NUM_STAGES; i++) begin
            reg_pipeline[i] <= {DATA_WIDTH{1'b0}};
        end
        reg_result <= {DATA_WIDTH+1{1'b0}};
        reg_o_en <= 1'b0;
    end else begin
        // Capture input operands
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
        end
        // Pipeline stages
        for (int i = 0; i < NUM_STAGES; i++) begin
            if (i == 0) begin
                reg_pipeline[i] <= reg_adda + reg_addb;
            end else begin
                reg_pipeline[i] <= reg_pipeline[i-1];
            end
        end
        // Calculate the result
        reg_result <= {1'b0, reg_adda} + {1'b0, reg_addb};
        // Set output enable signal
        if (i_en) begin
            reg_o_en <= 1'b1;
        end else begin
            reg_o_en <= 1'b0;
        end
    end
end

// Assign outputs
assign result = reg_result;
assign o_en = reg_o_en;

endmodule