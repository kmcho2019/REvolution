module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [8:0] data_lock;  // [8] is valid flag, [7:0] stores first byte

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset clears all registers
        data_lock <= 9'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!data_lock[8]) begin
                // Store first byte and set flag (bit 8)
                data_lock <= {1'b1, data_in};
            end else begin
                // Concatenate with stored byte and output
                data_out <= {data_lock[7:0], data_in};
                valid_out <= 1'b1;
                data_lock <= 9'b0;  // Clear for next pair
            end
        end
    end
end

endmodule