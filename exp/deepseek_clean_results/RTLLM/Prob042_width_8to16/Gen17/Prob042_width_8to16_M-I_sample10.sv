module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [8:0] storage; // [8] is valid bit, [7:0] is stored data

always @(posedge clk) begin
    if (!rst_n) begin
        storage <= 9'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Storage and output logic
        if (valid_in) begin
            if (storage[8]) begin // If we have stored data
                // Form 16-bit output
                data_out <= {storage[7:0], data_in};
                valid_out <= 1'b1;
                storage <= 9'b0; // Clear storage
            end else begin
                // Store first byte with valid bit
                storage <= {1'b1, data_in};
            end
        end
    end
end

endmodule