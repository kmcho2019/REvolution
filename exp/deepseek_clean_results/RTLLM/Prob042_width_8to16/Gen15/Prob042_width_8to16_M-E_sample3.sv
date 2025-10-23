module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Pipeline stage 1 registers
reg stage1_valid;
reg [7:0] stage1_data;

// Pipeline stage 2 registers
reg stage2_valid;
reg [15:0] stage2_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline stages
        stage1_valid <= 1'b0;
        stage1_data <= 8'b0;
        stage2_valid <= 1'b0;
        stage2_data <= 16'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Stage 1: Capture first byte when valid
        if (valid_in) begin
            stage1_valid <= 1'b1;
            stage1_data <= data_in;
        end else begin
            stage1_valid <= 1'b0;
        end

        // Stage 2: Concatenate when we have both bytes
        if (stage1_valid && valid_in) begin
            stage2_valid <= 1'b1;
            stage2_data <= {stage1_data, data_in};
        end else begin
            stage2_valid <= 1'b0;
        end

        // Output stage
        valid_out <= stage2_valid;
        if (stage2_valid) begin
            data_out <= stage2_data;
        end
    end
end

endmodule