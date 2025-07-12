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

reg [DATA_WIDTH-1:0] ring_buffer [0:BUFFER_SIZE-1]; // Ring buffer
reg [BUFFER_SIZE-1:0] head; // Head pointer
reg [BUFFER_SIZE-1:0] tail; // Tail pointer
reg [BUFFER_SIZE-1:0] count; // Count of data in the buffer

// Combinational logic for next head and tail pointers
wire [BUFFER_SIZE-1:0] next_head;
assign next_head = (Rst) ? 0 :
                   (EN && !RW && count < BUFFER_SIZE) ? (head + 1) % BUFFER_SIZE :
                   (head);

wire [BUFFER_SIZE-1:0] next_tail;
assign next_tail = (Rst) ? 0 :
                   (EN && RW && count > 0) ? (tail + 1) % BUFFER_SIZE :
                   (tail);

wire next_count;
assign next_count = (Rst) ? 0 :
                    (EN && !RW && count < BUFFER_SIZE) ? count + 1 :
                    (EN && RW && count > 0) ? count - 1 :
                    (count);

// Sequential logic for head, tail, and dataOut
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        head <= 0; // Initialize head pointer to 0
        tail <= 0; // Initialize tail pointer to 0
        count <= 0; // Initialize count to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            ring_buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize ring buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        head <= next_head; // Update head pointer
        tail <= next_tail; // Update tail pointer
        count <= next_count; // Update count
        if (!RW && count < BUFFER_SIZE) begin // Write operation
            ring_buffer[head] <= dataIn; // Write data to ring buffer
        end else if (RW && count > 0) begin // Read operation
            dataOut <= ring_buffer[tail]; // Read data from ring buffer
        end
    end
end

// Continuous assignments for EMPTY and FULL flags
assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count is equal to BUFFER_SIZE

endmodule