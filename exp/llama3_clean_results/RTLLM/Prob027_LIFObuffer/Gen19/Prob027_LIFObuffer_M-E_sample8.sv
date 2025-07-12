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

reg [DATA_WIDTH-1:0] circular_buf [0:BUFFER_SIZE-1]; // Circular buffer
reg [1:0] write_ptr; // Write pointer
reg [1:0] read_ptr; // Read pointer
reg [1:0] count; // Counter for valid entries

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count is equal to BUFFER_SIZE

// Sequential logic for circular buffer and pointers
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        write_ptr <= 0; // Initialize write pointer to 0
        read_ptr <= 0; // Initialize read pointer to 0
        count <= 0; // Initialize count to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            circular_buf[i] <= {DATA_WIDTH{1'b0}}; // Initialize circular buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW &&!FULL) begin // Push operation
            circular_buf[write_ptr] <= dataIn; // Write data to circular buffer
            write_ptr <= (write_ptr + 1) % BUFFER_SIZE; // Increment write pointer modulo BUFFER_SIZE
            count <= count + 1; // Increment count
        end else if (RW &&!EMPTY) begin // Pop operation
            dataOut <= circular_buf[read_ptr]; // Read data from circular buffer
            read_ptr <= (read_ptr + 1) % BUFFER_SIZE; // Increment read pointer modulo BUFFER_SIZE
            count <= count - 1; // Decrement count
        end
    end
end

endmodule