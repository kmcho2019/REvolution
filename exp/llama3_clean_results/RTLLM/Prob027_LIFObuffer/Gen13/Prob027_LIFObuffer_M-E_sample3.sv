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

reg [DATA_WIDTH-1:0] buffer [0:BUFFER_SIZE-1]; // Circular buffer
reg [1:0] write_ptr; // Write pointer
reg [1:0] read_ptr; // Read pointer

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (write_ptr == read_ptr); // Buffer is empty when write_ptr equals read_ptr
assign FULL = ((write_ptr + 1) % BUFFER_SIZE == read_ptr); // Buffer is full when write_ptr is one position ahead of read_ptr

// Sequential logic for buffer management
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        write_ptr <= 0; // Initialize write pointer to 0
        read_ptr <= 0; // Initialize read pointer to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW &&!FULL) begin // Push operation
            buffer[write_ptr] <= dataIn; // Push data onto buffer
            write_ptr <= (write_ptr + 1) % BUFFER_SIZE; // Increment write pointer
        end else if (RW &&!EMPTY) begin // Pop operation
            dataOut <= buffer[read_ptr]; // Pop data from buffer
            buffer[read_ptr] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            read_ptr <= (read_ptr + 1) % BUFFER_SIZE; // Increment read pointer
        end
    end
end

endmodule