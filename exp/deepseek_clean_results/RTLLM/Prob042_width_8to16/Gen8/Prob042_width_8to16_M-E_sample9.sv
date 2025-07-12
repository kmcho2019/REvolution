module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [15:0] shift_reg;
reg has_first_byte;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 16'b0;
        has_first_byte <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Shift register update
        if (valid_in) begin
            if (!has_first_byte) begin
                shift_reg[15:8] <= data_in;
                has_first_byte <= 1'b1;
            end else begin
                shift_reg[7:0] <= data_in;
                has_first_byte <= 1'b0;
                // Schedule output for next cycle
                valid_out <= 1'b1;
            end
        end
        
        // Output register update (one cycle delayed)
        if (valid_out) begin
            data_out <= shift_reg;
        end
    end
end

endmodule