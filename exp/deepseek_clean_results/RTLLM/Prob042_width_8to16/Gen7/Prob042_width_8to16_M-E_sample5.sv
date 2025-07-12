module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Pipeline stage registers
reg [7:0] first_byte;
reg first_byte_valid;
reg output_ready;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        first_byte <= 8'b0;
        first_byte_valid <= 1'b0;
        output_ready <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Stage 1: First byte capture
        if (valid_in && !first_byte_valid) begin
            first_byte <= data_in;
            first_byte_valid <= 1'b1;
            output_ready <= 1'b0;
        end 
        // Stage 2: Second byte capture and output generation
        else if (valid_in && first_byte_valid) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
            first_byte_valid <= 1'b0;
            output_ready <= 1'b1;
        end
        
        // Clear ready flag after one cycle
        if (output_ready) begin
            output_ready <= 1'b0;
        end
    end
end

endmodule