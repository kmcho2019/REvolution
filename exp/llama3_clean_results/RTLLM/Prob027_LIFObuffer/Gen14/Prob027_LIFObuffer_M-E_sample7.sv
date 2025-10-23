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
reg [1:0] head; // Head pointer (Gray code counter)
reg [1:0] tail; // Tail pointer (Gray code counter)
reg [DATA_WIDTH-1:0] temp; // Temporary register for data

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (head == tail && temp == {DATA_WIDTH{1'b0}}); // Buffer is empty when head equals tail and temp is 0
assign FULL = (head == tail && temp!= {DATA_WIDTH{1'b0}}); // Buffer is full when head equals tail and temp is not 0

// Sequential logic for head and tail pointers
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        head <= 0; // Initialize head pointer to 0
        tail <= 0; // Initialize tail pointer to 0
        temp <= {DATA_WIDTH{1'b0}}; // Initialize temporary register to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}}; // Initialize buffer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW &&!FULL) begin // Write operation
            buffer[head] <= dataIn; // Write data to buffer
            head <= head + 1; // Increment head pointer (Gray code counter)
            if (head == BUFFER_SIZE) begin
                head <= 0; // Wrap around to beginning of buffer
            end
            temp <= dataIn; // Update temporary register
        end else if (RW &&!EMPTY) begin // Read operation
            dataOut <= buffer[tail]; // Read data from buffer
            buffer[tail] <= {DATA_WIDTH{1'b0}}; // Clear read data
            tail <= tail + 1; // Increment tail pointer (Gray code counter)
            if (tail == BUFFER_SIZE) begin
                tail <= 0; // Wrap around to beginning of buffer
            end
            temp <= {DATA_WIDTH{1'b0}}; // Update temporary register
        end
    end
end

endmodule