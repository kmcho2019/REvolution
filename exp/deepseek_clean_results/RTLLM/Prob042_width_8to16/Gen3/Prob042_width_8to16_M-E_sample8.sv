module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [15:0] accumulator;
reg [1:0] byte_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 16'b0;
        byte_count <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Shift and accumulate new byte
            accumulator <= {accumulator[7:0], data_in};
            byte_count <= byte_count + 1;
            
            // Check if we have two bytes
            if (byte_count == 2'b1) begin
                data_out <= {accumulator[7:0], data_in};
                valid_out <= 1'b1;
                byte_count <= 2'b0;
            end
        end
    end
end

endmodule