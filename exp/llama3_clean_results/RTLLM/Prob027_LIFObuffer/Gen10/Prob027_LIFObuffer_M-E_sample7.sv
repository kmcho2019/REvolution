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

reg [DATA_WIDTH-1:0] ram [0:BUFFER_SIZE-1]; // RAM array
reg [BUFFER_SIZE-1:0] read_ptr; // Read pointer
reg [BUFFER_SIZE-1:0] write_ptr; // Write pointer
reg [BUFFER_SIZE-1:0] count; // Count of elements in the buffer

// Initialize EMPTY and FULL flags based on the count
always @(*) begin
    EMPTY = (count == 0); // Buffer is empty when count is 0
    FULL = (count == BUFFER_SIZE); // Buffer is full when count equals BUFFER_SIZE
end

// Sequential logic for read and write pointers, count, and dataOut
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        read_ptr <= 0; // Initialize read pointer to 0
        write_ptr <= 0; // Initialize write pointer to 0
        count <= 0; // Initialize count to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            ram[i] <= {DATA_WIDTH{1'b0}}; // Initialize RAM array to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            ram[write_ptr] <= dataIn; // Write data to RAM array
            write_ptr <= (write_ptr + 1) % BUFFER_SIZE; // Increment write pointer
            count <= count + 1; // Increment count
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= ram[read_ptr]; // Read data from RAM array
            ram[read_ptr] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            read_ptr <= (read_ptr + 1) % BUFFER_SIZE; // Increment read pointer
            count <= count - 1; // Decrement count
        end
    end
end

endmodule