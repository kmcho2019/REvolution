module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] data_buffer [0:3];
reg [1:0] wr_ptr;
reg buffer_full;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <= 2'b0;
        buffer_full <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
        // Clear buffer
        data_buffer[0] <= 8'b0;
        data_buffer[1] <= 8'b0;
        data_buffer[2] <= 8'b0;
        data_buffer[3] <= 8'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Store input data
            data_buffer[wr_ptr] <= data_in;
            
            // Update pointer and full flag
            if (wr_ptr == 2'b11) begin
                wr_ptr <= 2'b0;
                buffer_full <= 1'b1;
            end
            else begin
                wr_ptr <= wr_ptr + 1'b1;
                buffer_full <= 1'b0;
            end
            
            // When buffer is full, compute sum
            if (buffer_full && wr_ptr == 2'b11) begin
                data_out <= data_buffer[0] + data_buffer[1] + 
                           data_buffer[2] + data_buffer[3];
                valid_out <= 1'b1;
            end
        end
    end
end

endmodule