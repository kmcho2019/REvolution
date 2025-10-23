module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [8:0] storage_reg; // [8] = valid bit, [7:0] = stored data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        storage_reg <= 9'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        // Default assignments
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!storage_reg[8]) begin
                // Store first byte with valid flag
                storage_reg <= {1'b1, data_in};
            end else begin
                // Concatenate and output
                data_out <= {storage_reg[7:0], data_in};
                valid_out <= 1'b1;
                storage_reg <= 9'b0; // Clear storage
            end
        end
    end
end

endmodule