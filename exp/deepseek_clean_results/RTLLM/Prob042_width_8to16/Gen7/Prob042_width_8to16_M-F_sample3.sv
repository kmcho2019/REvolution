module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg has_first_byte;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        has_first_byte <= 1'b0;
    end
end

// Main operation logic
always @(posedge clk) begin
    if (!rst_n) begin
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!has_first_byte) begin
                // Store first byte
                data_lock <= data_in;
                has_first_byte <= 1'b1;
            end
            else begin
                // Concatenate and output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                has_first_byte <= 1'b0;
            end
        end
    end
end

endmodule