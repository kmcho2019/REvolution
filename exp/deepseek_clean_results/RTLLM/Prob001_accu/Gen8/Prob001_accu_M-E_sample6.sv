module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // 4-entry shift register (8-bit each)
    reg [7:0] shift_reg [0:3];
    reg [1:0] wr_ptr;  // Circular write pointer
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            shift_reg[0] <= 8'b0;
            shift_reg[1] <= 8'b0;
            shift_reg[2] <= 8'b0;
            shift_reg[3] <= 8'b0;
            wr_ptr <= 2'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Store input in shift register
                shift_reg[wr_ptr] <= data_in;
                
                // Update write pointer (circular buffer)
                if (wr_ptr == 2'b11) begin
                    wr_ptr <= 2'b00;
                    // When buffer is full, compute sum in parallel
                    data_out <= {2'b0, shift_reg[0]} + 
                               {2'b0, shift_reg[1]} + 
                               {2'b0, shift_reg[2]} + 
                               {2'b0, shift_reg[3]};
                    valid_out <= 1'b1;
                end
                else begin
                    wr_ptr <= wr_ptr + 1'b1;
                end
            end
        end
    end

endmodule