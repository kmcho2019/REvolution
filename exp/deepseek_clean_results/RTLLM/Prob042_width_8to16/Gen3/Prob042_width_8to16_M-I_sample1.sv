module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_data;
reg has_first_half;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stored_data <= 8'b0;
        has_first_half <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // State machine logic
        if (valid_in) begin
            if (!has_first_half) begin
                // Store first half
                stored_data <= data_in;
                has_first_half <= 1'b1;
            end
            else begin
                // Output complete 16-bit word
                data_out <= {stored_data, data_in};
                valid_out <= 1'b1;
                has_first_half <= 1'b0;
            end
        end
    end
end

endmodule