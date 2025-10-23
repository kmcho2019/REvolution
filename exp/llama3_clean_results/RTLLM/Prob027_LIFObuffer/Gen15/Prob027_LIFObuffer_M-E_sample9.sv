module LIFObuffer_linked_list #(
    parameter DATA_WIDTH = 4,
    parameter BUFFER_SIZE = 4
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

// Node structure for the linked list
reg [DATA_WIDTH-1:0] node_data [0:BUFFER_SIZE-1];
reg [2:0] node_next [0:BUFFER_SIZE-1];

// Head and tail pointers
reg [2:0] head;
reg [2:0] tail;

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (head == 0); // Buffer is empty when head is 0
assign FULL = (tail == BUFFER_SIZE); // Buffer is full when tail is equal to BUFFER_SIZE

// Sequential logic for linked list management
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        head <= 0; // Initialize head to 0
        tail <= 0; // Initialize tail to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            node_data[i] <= {DATA_WIDTH{1'b0}}; // Initialize node data to 0
            node_next[i] <= 0; // Initialize node next pointer to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (!EMPTY) begin // Buffer is not empty
                dataOut <= node_data[head]; // Pop data from the head of the list
                head <= node_next[head]; // Update head to point to the next node
            end
        end else begin // Write operation
            if (!FULL) begin // Buffer is not full
                node_data[tail] <= dataIn; // Push data onto the tail of the list
                node_next[tail] <= head; // Update next pointer of the new tail
                tail <= tail + 1; // Increment tail
                head <= tail - 1; // Update head to point to the new tail
            end
        end
    end
end

endmodule