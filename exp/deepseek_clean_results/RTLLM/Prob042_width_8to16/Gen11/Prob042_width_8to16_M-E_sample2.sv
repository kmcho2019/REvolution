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

// Pipeline control
wire stage1_ready = stage1_valid;
wire capture_first = valid_in && !stage1_ready;
wire capture_second = valid_in && stage1_ready;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'b0;
        stage1_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // First stage: capture first byte
        if (capture_first) begin
            stage1_reg <= data_in;
            stage1_valid <= 1'b1;
        end
        // Clear first stage after successful concatenation
        else if (capture_second) begin
            stage1_valid <= 1'b0;
        end

        // Output generation
        valid_out <= capture_second;
        if (capture_second) begin
            data_out <= {stage1_reg, data_in};
        end else begin
            data_out <= 16'b0;  // Default output when not valid
        end
    end
end

endmodule