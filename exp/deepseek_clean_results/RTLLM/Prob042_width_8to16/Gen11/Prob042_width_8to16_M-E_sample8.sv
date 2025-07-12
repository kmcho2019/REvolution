module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Pipeline registers
reg [7:0] stage1_reg;
reg stage1_valid;
reg [7:0] stage2_reg;
reg stage2_valid;

// Data counter (0 or 1)
reg data_counter;

always @(posedge clk) begin
    if (!rst_n) begin
        // Reset all registers and counters
        stage1_reg <= 8'b0;
        stage1_valid <= 1'b0;
        stage2_reg <= 8'b0;
        stage2_valid <= 1'b0;
        data_counter <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Pipeline stage 1: Capture input data
        if (valid_in) begin
            stage1_reg <= data_in;
            stage1_valid <= 1'b1;
            data_counter <= ~data_counter;
        end else begin
            stage1_valid <= 1'b0;
        end
        
        // Pipeline stage 2: Process data
        stage2_reg <= stage1_reg;
        stage2_valid <= stage1_valid;
        
        // Output generation
        if (stage2_valid && data_counter) begin
            // When we have two valid bytes (counter toggled twice)
            data_out <= {stage2_reg, stage1_reg};
            valid_out <= 1'b1;
        end
    end
end

endmodule