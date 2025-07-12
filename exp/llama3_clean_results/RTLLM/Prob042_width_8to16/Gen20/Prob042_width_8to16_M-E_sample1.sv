module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] buffer[1:0]; // Circular buffer to store input data
reg [1:0] read_ptr; // Read pointer for the buffer
reg [1:0] write_ptr; // Write pointer for the buffer
reg data_available; // Flag to indicate when two valid data are available
reg [1:0] data_count; // Counter to keep track of the number of valid data in the buffer

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_ptr <= 2'b0;
        write_ptr <= 2'b0;
        data_available <= 1'b0;
        data_count <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            // Write input data to the buffer
            buffer[write_ptr] <= data_in;
            // Increment the write pointer
            write_ptr <= write_ptr + 1;
            // Increment the data count
            data_count <= data_count + 1;
            // Check if the buffer is full
            if (data_count == 2) begin
                // Generate output data
                data_out <= {buffer[read_ptr], buffer[read_ptr + 1]};
                // Assert the valid_out signal
                valid_out <= 1'b1;
                // Reset the data available flag
                data_available <= 1'b0;
                // Reset the data count
                data_count <= 2'b0;
                // Increment the read pointer
                read_ptr <= read_ptr + 2;
            end else begin
                // Set the data available flag
                data_available <= 1'b1;
            end
        end else begin
            // Reset the valid_out signal
            valid_out <= 1'b0;
        end
    end
end

endmodule