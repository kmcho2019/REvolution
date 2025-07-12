module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Gray-encoded counter for low power
    reg [1:0] count;
    wire [1:0] next_count = (count == 2'b11) ? 2'b00 : (count + 1'b1);
    
    // Pipeline registers
    reg [9:0] stage1_sum;
    reg [9:0] stage2_sum;
    reg [7:0] stage2_data;
    
    // Control signals
    wire stage2_enable = (count == 2'b10) || (count == 2'b11);
    wire output_ready = (count == 2'b11) && valid_in;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            stage1_sum <= 10'b0;
            stage2_sum <= 10'b0;
            stage2_data <= 8'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            // Pipeline stage 1: Accumulation
            if (valid_in) begin
                count <= next_count;
                stage1_sum <= (count == 2'b00) ? data_in : (stage1_sum + data_in);
                stage2_data <= data_in;
            end
            
            // Pipeline stage 2: Final sum calculation
            if (valid_in && stage2_enable) begin
                stage2_sum <= stage1_sum + stage2_data;
            end
            
            // Output generation
            if (output_ready) begin
                data_out <= stage1_sum + stage2_data;
                valid_out <= 1'b1;
            end
        end
    end

endmodule