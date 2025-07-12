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
reg [$clog2(BUFFER_SIZE):0] HEAD; // Read pointer
reg [$clog2(BUFFER_SIZE):0] TAIL; // Write pointer

always @(posedge Clk) begin
    if (Rst) begin
        HEAD <= 0; // Initialize read pointer
        TAIL <= 0; // Initialize write pointer
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW) begin // Write operation
            buffer[TAIL] <= dataIn; // Write data to buffer
            TAIL <= (TAIL + 1) % BUFFER_SIZE; // Increment write pointer
        end else if (RW) begin // Read operation
            dataOut <= buffer[HEAD]; // Read data from buffer
            buffer[HEAD] <= {DATA_WIDTH{1'b0}}; // Clear read data
            HEAD <= (HEAD + 1) % BUFFER_SIZE; // Increment read pointer
        end
    end
end

// Compact logic for EMPTY and FULL flags
assign EMPTY = (HEAD == TAIL);
assign FULL = ((TAIL + 1) % BUFFER_SIZE == HEAD);

endmodule