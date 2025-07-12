module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] byte_count, next_byte_count;
logic msg_received, next_msg_received;

always_comb begin
    next_byte_count = byte_count;
    next_msg_received = 0;
    
    if(in[3] && byte_count == 0) begin
        next_byte_count = 0; // Reset counter when a new message starts
    end
    else if(byte_count < 2) begin
        next_byte_count = byte_count + 1; // Increment counter for each byte
    end
    else begin
        next_byte_count = 0; // Reset counter after a message is fully received
    end
    
    if(byte_count == 2) begin
        next_msg_received = 1; // Set msg_received flag when a message is complete
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
        msg_received <= 0;
    end
    else begin
        byte_count <= next_byte_count;
        msg_received <= next_msg_received;
    end
end

assign done = msg_received;

endmodule