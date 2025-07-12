module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State registers
reg has_first_byte;
reg [7:0] first_byte;

// Sequential logic for state updates
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all state
        has_first_byte <= 1'b0;
        first_byte <= 8'h00;
    end else if (valid_in) begin
        if (!has_first_byte) begin
            // Store first byte and set flag
            first_byte <= data_in;
            has_first_byte <= 1'b1;
        end else begin
            // Clear flag after second byte
            has_first_byte <= 1'b0;
        end
    end
end

// Output generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset outputs
        valid_out <= 1'b0;
        data_out <= 16'h0000;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        data_out <= data_out; // Maintain previous value
        
        // Generate output when second byte arrives
        if (valid_in && has_first_byte) begin
            data_out <= {first_byte, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule