module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] buffer [0:BUFFER_SIZE-1]; // Circular buffer
reg [BUFFER_SIZE-1:0] head; // Head pointer
reg [BUFFER_SIZE-1:0] tail; // Tail pointer
reg [BUFFER_SIZE-1:0] count; // Count of valid data in the buffer

assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count is equal to BUFFER_SIZE

// Sequential logic for head, tail, and count
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        head <= 0; // Initialize head pointer to 0
        tail <= 0; // Initialize tail pointer to 0
        count <= 0; // Initialize count to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            buffer[head] <= dataIn; // Push data onto buffer
            head <= (head + 1) % BUFFER_SIZE; // Increment head pointer
            count <= count + 1; // Increment count
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= buffer[tail]; // Pop data from buffer
            buffer[tail] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            tail <= (tail + 1) % BUFFER_SIZE; // Increment tail pointer
            count <= count - 1; // Decrement count
        end
    end
end

endmodule