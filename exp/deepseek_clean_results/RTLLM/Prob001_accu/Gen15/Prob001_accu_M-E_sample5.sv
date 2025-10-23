module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Circular buffer to store last 4 valid inputs
    reg [7:0] data_buffer [0:3];
    reg [1:0] wr_ptr;       // Write pointer
    reg [1:0] valid_count;  // Count of valid entries in buffer
    
    // Combinational sum calculation
    wire [9:0] sum = {2'b0, data_buffer[0]} + 
                     {2'b0, data_buffer[1]} + 
                     {2'b0, data_buffer[2]} + 
                     {2'b0, data_buffer[3]};
    
    // Buffer management and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_buffer[0] <= 8'b0;
            data_buffer[1] <= 8'b0;
            data_buffer[2] <= 8'b0;
            data_buffer[3] <= 8'b0;
            wr_ptr <= 2'b0;
            valid_count <= 2'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            // Store new data when valid
            if (valid_in) begin
                data_buffer[wr_ptr] <= data_in;
                
                // Update write pointer circularly
                wr_ptr <= (wr_ptr == 2'b11) ? 2'b0 : wr_ptr + 1'b1;
                
                // Update valid count (max at 4)
                if (valid_count != 2'b11)
                    valid_count <= valid_count + 1'b1;
                
                // Generate output when we have 4 valid entries
                if (valid_count == 2'b11) begin
                    data_out <= sum;
                    valid_out <= 1'b1;
                end
            end
        end
    end

endmodule