module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_byte;  // State flag (0=IDLE, 1=has first byte)
reg [7:0] first_byte_reg;
reg valid_in_d1;     // Registered version of valid_in for pipelining

// Sequential logic (state and data storage)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Synchronous reset
        has_first_byte <= 1'b0;
        first_byte_reg <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        valid_in_d1 <= 1'b0;
    end else begin
        // Pipeline valid_in for better timing
        valid_in_d1 <= valid_in;
        
        // Default outputs
        valid_out <= 1'b0;
        
        // State and data storage logic
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte and set flag
                first_byte_reg <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                // Concatenate and prepare output
                data_out <= {first_byte_reg, data_in};
                has_first_byte <= 1'b0;
            end
        end
        
        // Output generation (pipelined by one cycle)
        if (valid_in_d1 && has_first_byte) begin
            valid_out <= 1'b1;
        end
    end
end

endmodule