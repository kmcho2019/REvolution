module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Shift register for data collection
reg [15:0] data_shift;
reg [1:0] valid_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data_shift <= 16'b0;
        valid_counter <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Shift register operation
        if (valid_in) begin
            data_shift <= {data_shift[7:0], data_in};
            valid_counter <= valid_counter + 1;
        end
        
        // Output generation logic
        if (valid_counter == 2'b10) begin
            data_out <= data_shift;
            valid_out <= 1'b1;
            valid_counter <= 2'b0;  // Reset counter
        end
    end
end

endmodule