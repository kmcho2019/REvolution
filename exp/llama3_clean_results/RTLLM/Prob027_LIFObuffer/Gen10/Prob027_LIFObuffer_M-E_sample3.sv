module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] cb_buffer [0:BUFFER_SIZE-1]; // Circular buffer
reg [BUFFER_SIZE-1:0] read_ptr; // Read pointer
reg [BUFFER_SIZE-1:0] write_ptr; // Write pointer
reg [BUFFER_SIZE:0] count; // Count register

// Combinational logic for next read and write pointers
always @(*) begin
    if (Rst) begin
        read_ptr = 0;
        write_ptr = 0;
    end else if (EN) begin
        if (!RW && count < BUFFER_SIZE) begin // Push operation
            write_ptr = (write_ptr + 1) % BUFFER_SIZE;
        end else if (RW && count > 0) begin // Pop operation
            read_ptr = (read_ptr + 1) % BUFFER_SIZE;
        end
    end
end

// Sequential logic for buffer update and count
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            cb_buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        count <= 0; // Initialize count to 0
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && count < BUFFER_SIZE) begin // Push operation
            cb_buffer[write_ptr] <= dataIn; // Push data into buffer
            count <= count + 1; // Increment count
        end else if (RW && count > 0) begin // Pop operation
            dataOut <= cb_buffer[read_ptr]; // Pop data from buffer
            cb_buffer[read_ptr] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            count <= count - 1; // Decrement count
        end
    end
end

// Continuous assignments for EMPTY and FULL flags
assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count is equal to BUFFER_SIZE

endmodule