module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [15:0] shift_reg;
reg [1:0] bit_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 16'b0;
        bit_counter <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Shift register and counter update
        if (valid_in) begin
            shift_reg <= {shift_reg[7:0], data_in};
            bit_counter <= bit_counter + 1;
            
            // Generate output when we have 16 bits (2 bytes)
            if (bit_counter == 2'b01) begin
                data_out <= {shift_reg[7:0], data_in};
                valid_out <= 1'b1;
                bit_counter <= 2'b0;
            end
        end
    end
end

endmodule