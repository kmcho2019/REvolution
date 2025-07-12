module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg;
reg [1:0] init_counter;
reg valid_data;
reg last_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
        data_out <= 1'b0;
        init_counter <= 2'b00;
        valid_data <= 1'b0;
        last_data <= 1'b0;
    end else begin
        // Track previous data_in to detect changes
        last_data <= data_in;
        
        // Only shift when data_in changes to reduce switching
        if (data_in != last_data) begin
            shift_reg <= {shift_reg[1:0], data_in};
            
            // Count first 3 samples before enabling detection
            if (!valid_data) begin
                init_counter <= init_counter + 1;
                valid_data <= (init_counter == 2'b10);
            end
        end
        
        // Simplified pattern detection using direct bit checks
        data_out <= valid_data & (!shift_reg[2] & shift_reg[1] & !shift_reg[0]);
    end
end

endmodule