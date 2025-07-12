module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define the buffer to store the most recent bytes
logic [7:0] byte_buffer [2:0];
logic [1:0] byte_counter;

// Signal to indicate if a message boundary has been detected
logic boundary_detected;

always_comb begin
    // Check if a message boundary is detected (first byte in buffer has in[3]=1)
    boundary_detected = (byte_buffer[0][3] == 1'b1);
end

always_ff @(posedge clk) begin
    if(reset) begin
        // Reset the buffer and counter
        for(int i = 0; i < 3; i++) begin
            byte_buffer[i] <= 8'd0;
        end
        byte_counter <= 2'd0;
    end
    else begin
        // Shift the buffer to the right (older bytes are discarded)
        byte_buffer[2] <= byte_buffer[1];
        byte_buffer[1] <= byte_buffer[0];
        byte_buffer[0] <= in; // New byte is added to the buffer
        
        // Update the byte counter based on the boundary detection
        if(boundary_detected) begin
            byte_counter <= 2'd1; // Reset counter when a boundary is detected
        end
        else if(byte_counter != 2'd3) begin
            byte_counter <= byte_counter + 1'd1; // Increment counter for each new byte
        end
    end
end

// Assert 'done' when three bytes have been received after a message boundary
assign done = (byte_counter == 2'd3);
endmodule