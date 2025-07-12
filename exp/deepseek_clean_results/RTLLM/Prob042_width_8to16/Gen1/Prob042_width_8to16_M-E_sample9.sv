module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [1:0] count;
reg [15:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        count <= 2'b00;
        shift_reg <= 16'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Shift in new data and increment count
            shift_reg <= {shift_reg[7:0], data_in};
            count <= count + 1;
            
            // When we have two inputs, output the result
            if (count == 2'b01) begin
                data_out <= {shift_reg[7:0], data_in};
                valid_out <= 1'b1;
                count <= 2'b00;
            end
        end
    end
end

endmodule