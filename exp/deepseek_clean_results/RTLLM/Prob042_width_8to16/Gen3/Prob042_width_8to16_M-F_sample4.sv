module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg has_first_half;
reg [7:0] first_half;
reg delayed_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        has_first_half <= 1'b0;
        first_half <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
        delayed_valid <= 1'b0;
    end
    else begin
        // Default assignments
        valid_out <= 1'b0;
        delayed_valid <= 1'b0;
        
        if (valid_in) begin
            if (has_first_half) begin
                // Second byte received - prepare output for next cycle
                data_out <= {first_half, data_in};
                delayed_valid <= 1'b1;
                has_first_half <= 1'b0;
            end
            else begin
                // First byte received - store it
                first_half <= data_in;
                has_first_half <= 1'b1;
            end
        end
        
        // Generate valid_out one cycle after concatenation
        valid_out <= delayed_valid;
    end
end

endmodule