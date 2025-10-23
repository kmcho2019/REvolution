module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] data_buffer [0:3];
reg [1:0] fill_count;
wire buffer_full = (fill_count == 2'b11);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fill_count <= 2'b0;
        valid_out <= 1'b0;
        data_buffer[0] <= 8'b0;
        data_buffer[1] <= 8'b0;
        data_buffer[2] <= 8'b0;
        data_buffer[3] <= 8'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Shift new data into buffer
            data_buffer[3] <= data_buffer[2];
            data_buffer[2] <= data_buffer[1];
            data_buffer[1] <= data_buffer[0];
            data_buffer[0] <= data_in;
            
            // Update fill counter
            fill_count <= buffer_full ? 2'b0 : fill_count + 1'b1;
            
            // Generate output when buffer is full
            if (buffer_full) begin
                data_out <= data_buffer[0] + data_buffer[1] + 
                            data_buffer[2] + data_buffer[3];
                valid_out <= 1'b1;
            end
        end
    end
end

endmodule