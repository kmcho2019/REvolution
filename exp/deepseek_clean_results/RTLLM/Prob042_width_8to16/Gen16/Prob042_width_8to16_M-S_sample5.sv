module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_byte;
reg waiting_for_second;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_byte <= 8'b0;
        waiting_for_second <= 1'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;  // Default to not valid
        
        if (valid_in) begin
            if (!waiting_for_second) begin
                // Store first byte and wait for second
                first_byte <= data_in;
                waiting_for_second <= 1'b1;
            end else begin
                // Concatenate with second byte and output
                data_out <= {first_byte, data_in};
                valid_out <= 1'b1;
                waiting_for_second <= 1'b0;
            end
        end
    end
end

endmodule