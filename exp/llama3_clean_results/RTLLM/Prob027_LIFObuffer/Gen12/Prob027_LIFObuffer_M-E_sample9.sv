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

reg [DATA_WIDTH-1:0] buffer [0:BUFFER_SIZE-1]; // Circular buffer array
reg [1:0] read_ptr; // Read pointer
reg [1:0] write_ptr; // Write pointer
reg [1:0] count; // Count of valid data elements

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count is equal to BUFFER_SIZE

// Sequential logic for buffer operations
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        read_ptr <= 0; // Initialize read pointer to 0
        write_ptr <= 0; // Initialize write pointer to 0
        count <= 0; // Initialize count to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (!EMPTY) begin // Buffer is not empty
                dataOut <= buffer[read_ptr]; // Read data from buffer
                buffer[read_ptr] <= {DATA_WIDTH{1'b0}}; // Clear read data
                read_ptr <= (read_ptr + 1) % BUFFER_SIZE; // Increment read pointer with wrap-around
                count <= count - 1; // Decrement count
            end
        end else begin // Write operation
            if (!FULL) begin // Buffer is not full
                buffer[write_ptr] <= dataIn; // Write data to buffer
                write_ptr <= (write_ptr + 1) % BUFFER_SIZE; // Increment write pointer with wrap-around
                count <= count + 1; // Increment count
            end
        end
    end
end

endmodule