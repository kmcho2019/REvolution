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
reg [1:0] RP; // Read pointer
reg [1:0] WP; // Write pointer
reg [1:0] count; // Entry counter

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (count == 0); // Buffer is empty when count is 0
assign FULL = (count == BUFFER_SIZE); // Buffer is full when count equals BUFFER_SIZE

// Sequential logic for buffer management
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        RP <= 0; // Initialize read pointer
        WP <= 0; // Initialize write pointer
        count <= 0; // Initialize entry counter
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (!EMPTY) begin // Buffer is not empty
                dataOut <= buffer[RP]; // Pop data from buffer
                buffer[RP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
                RP <= (RP + 1) % BUFFER_SIZE; // Increment read pointer with wrap-around
                count <= count - 1; // Decrement entry counter
            end
        end else begin // Write operation
            if (!FULL) begin // Buffer is not full
                buffer[WP] <= dataIn; // Push data onto buffer
                WP <= (WP + 1) % BUFFER_SIZE; // Increment write pointer with wrap-around
                count <= count + 1; // Increment entry counter
            end
        end
    end
end

endmodule