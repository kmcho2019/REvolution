module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [1:0] byte_counter;
reg [15:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 16'b0;
        byte_counter <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0; // Default assignment
        
        if (valid_in) begin
            // Shift in new byte
            shift_reg <= {shift_reg[7:0], data_in};
            byte_counter <= byte_counter + 1;
            
            // Check if we have two bytes
            if (byte_counter == 2'b01) begin
                data_out <= {shift_reg[7:0], data_in};
                valid_out <= 1'b1;
                byte_counter <= 2'b0;
            end
        end
    end
end

endmodule