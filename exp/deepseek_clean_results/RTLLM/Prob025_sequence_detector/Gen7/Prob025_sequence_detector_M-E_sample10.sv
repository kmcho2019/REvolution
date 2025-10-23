module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Circular buffer to store last 4 bits
reg [3:0] history_buffer;
reg [1:0] write_ptr;  // Points to next write location

// Detection logic
wire [3:0] window0 = {history_buffer[2:0], data_in};
wire [3:0] window1 = {history_buffer[3], history_buffer[1:0], data_in};
wire [3:0] window2 = {history_buffer[3:2], history_buffer[0], data_in};
wire [3:0] window3 = {history_buffer[3:1], data_in};

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        history_buffer <= 4'b0;
        write_ptr <= 2'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update circular buffer
        history_buffer[write_ptr] <= data_in;
        write_ptr <= write_ptr + 1;
        
        // Parallel pattern matching
        sequence_detected <= (window0 == 4'b1001) || 
                            (window1 == 4'b1001) || 
                            (window2 == 4'b1001) || 
                            (window3 == 4'b1001);
    end
end

endmodule