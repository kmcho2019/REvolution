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
reg [BUFFER_SIZE-1:0] head; // Head pointer
reg [BUFFER_SIZE-1:0] tail; // Tail pointer

// Clock gating for buffer and pointers
wire clk_gated;
assign clk_gated = (EN || Rst) ? Clk : 1'b0;

// Sequential logic for buffer and pointers
always @(posedge clk_gated) begin
    if (Rst) begin // Active high reset
        head <= 0; // Initialize head pointer to 0
        tail <= 0; // Initialize tail pointer to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && (tail != (head - 1) % BUFFER_SIZE)) begin // Push operation
            buffer[tail] <= dataIn; // Push data onto buffer
            tail <= (tail + 1) % BUFFER_SIZE; // Increment tail pointer
        end else if (RW && (tail != head)) begin // Pop operation
            dataOut <= buffer[head]; // Pop data from buffer
            head <= (head + 1) % BUFFER_SIZE; // Increment head pointer
        end
    end
end

// Continuous assignments for EMPTY and FULL flags
assign EMPTY = (tail == head); // Buffer is empty when tail and head are equal
assign FULL = (tail == (head - 1) % BUFFER_SIZE); // Buffer is full when tail is one position ahead of head

endmodule