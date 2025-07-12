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
        // Clear all pipeline registers on reset
        stage1_valid <= 1'b0;
        stage1_data <= 8'b0;
        stage2_valid <= 1'b0;
        stage2_data <= 16'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Pipeline stage 1: Capture first byte or pass through
        if (valid_in) begin
            if (stage1_valid) begin
                // We have both bytes now - combine and move to stage 2
                stage2_valid <= 1'b1;
                stage2_data <= {stage1_data, data_in};
                stage1_valid <= 1'b0;  // Ready for new pair
            end else begin
                // Store first byte
                stage1_valid <= 1'b1;
                stage1_data <= data_in;
                stage2_valid <= 1'b0;  // Ensure stage2 doesn't hold old data
            end
        end else begin
            stage2_valid <= 1'b0;  // No new data this cycle
        end

        // Pipeline stage 2: Generate outputs
        valid_out <= stage2_valid;
        data_out <= stage2_data;
    end
end

endmodule