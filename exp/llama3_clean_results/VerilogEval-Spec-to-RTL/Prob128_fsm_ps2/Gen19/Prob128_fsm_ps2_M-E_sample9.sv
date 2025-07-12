module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Counter to track bytes received since last message start
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
    end else begin
        if(in[3]) begin // Message start byte detected
            byte_count <= 1; // Reset counter to 1 for the start byte
        end else if(byte_count != 0) begin // If counter is not zero, increment it
            byte_count <= byte_count + 1;
        end
    end
end

// Assert 'done' when a complete message (3 bytes) is received
assign done = (byte_count == 3);

// Optionally, you can reset byte_count to 0 when done is asserted to prepare for the next message
always_ff @(posedge clk) begin
    if(done) begin
        byte_count <= 0;
    end
end

endmodule