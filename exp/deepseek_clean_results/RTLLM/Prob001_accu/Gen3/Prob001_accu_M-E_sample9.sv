module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] shift_reg [0:3];  // 4-stage shift register
reg [1:0] wr_ptr;           // Write pointer
reg full_flag;              // Indicates when shift register is full

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        shift_reg[0] <= 8'b0;
        shift_reg[1] <= 8'b0;
        shift_reg[2] <= 8'b0;
        shift_reg[3] <= 8'b0;
        wr_ptr <= 2'b0;
        full_flag <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default values
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Shift in new data
            shift_reg[wr_ptr] <= data_in;
            
            // Update write pointer and full flag
            if (wr_ptr == 2'b11) begin
                full_flag <= 1'b1;
            end
            wr_ptr <= wr_ptr + 1'b1;
            
            // When shift register is full, compute sum
            if (full_flag) begin
                // Parallel addition of all 4 values
                data_out <= {2'b0, shift_reg[0]} + 
                           {2'b0, shift_reg[1]} + 
                           {2'b0, shift_reg[2]} + 
                           {2'b0, shift_reg[3]};
                valid_out <= 1'b1;
            end
        end
    end
end

endmodule