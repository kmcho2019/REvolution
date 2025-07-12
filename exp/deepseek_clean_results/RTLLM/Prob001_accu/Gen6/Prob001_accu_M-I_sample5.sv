module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] data_reg [0:3];  // Shift register for input storage
reg [1:0] wr_ptr;          // Write pointer instead of counter
reg full_flag;             // Indicates when 4 inputs are ready

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data_reg[0] <= 8'b0;
        data_reg[1] <= 8'b0;
        data_reg[2] <= 8'b0;
        data_reg[3] <= 8'b0;
        wr_ptr <= 2'b0;
        full_flag <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Store input in shift register
            data_reg[wr_ptr] <= data_in;
            
            // Update write pointer and full flag
            if (wr_ptr == 2'b11) begin
                wr_ptr <= 2'b0;
                full_flag <= 1'b1;
            end
            else begin
                wr_ptr <= wr_ptr + 1'b1;
                full_flag <= 1'b0;
            end
        end

        // Calculate and output sum when full
        if (full_flag) begin
            // Pipelined addition for better timing
            data_out <= {2'b0, data_reg[0]} + {2'b0, data_reg[1]} + 
                       {2'b0, data_reg[2]} + {2'b0, data_reg[3]};
            valid_out <= 1'b1;
            full_flag <= 1'b0;
        end
    end
end

endmodule