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
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] ring_buffer [0:BUFFER_SIZE-1]; // Ring buffer
reg [1:0] WP, RP; // Write and read pointers
reg [1:0] count; // Counter for buffer occupancy

assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count equals BUFFER_SIZE

// Sequential logic for ring buffer management
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        WP <= 0; // Initialize write pointer
        RP <= 0; // Initialize read pointer
        count <= 0; // Initialize counter
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            ring_buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize ring buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            ring_buffer[WP] <= dataIn; // Write data to ring buffer
            WP <= (WP + 1) % BUFFER_SIZE; // Increment write pointer modulo BUFFER_SIZE
            count <= count + 1; // Increment counter
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= ring_buffer[RP]; // Read data from ring buffer
            ring_buffer[RP] <= {DATA_WIDTH{1'b0}}; // Clear read data
            RP <= (RP + 1) % BUFFER_SIZE; // Increment read pointer modulo BUFFER_SIZE
            count <= count - 1; // Decrement counter
        end
    end
end

endmodule