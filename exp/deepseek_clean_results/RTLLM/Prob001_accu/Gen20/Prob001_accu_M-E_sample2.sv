module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register to store last 4 inputs
    reg [7:0] data_buffer [0:3];
    reg [1:0] wr_ptr;
    
    // Combinational sum of all 4 values
    wire [9:0] sum = {2'b0, data_buffer[0]} + 
                    {2'b0, data_buffer[1]} + 
                    {2'b0, data_buffer[2]} + 
                    {2'b0, data_buffer[3]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_buffer[0] <= 8'b0;
            data_buffer[1] <= 8'b0;
            data_buffer[2] <= 8'b0;
            data_buffer[3] <= 8'b0;
            wr_ptr <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            // Default outputs
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Shift in new data
                data_buffer[wr_ptr] <= data_in;
                
                // Update write pointer
                if (wr_ptr == 2'b11) begin
                    wr_ptr <= 2'b0;
                    // Output sum when buffer is full
                    data_out <= sum;
                    valid_out <= 1'b1;
                end else begin
                    wr_ptr <= wr_ptr + 1'b1;
                end
            end
        end
    end

endmodule