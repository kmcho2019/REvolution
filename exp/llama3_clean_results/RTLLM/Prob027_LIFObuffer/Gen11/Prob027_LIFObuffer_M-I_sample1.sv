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

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory
reg [BUFFER_SIZE-1:0] num_elements; // Number of elements in the stack

always @(posedge Clk) begin
    if (Rst) begin
        num_elements <= 0; // Initialize number of elements to 0 (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && num_elements < BUFFER_SIZE) begin // Push operation
            stack_mem[num_elements] <= dataIn; // Push data onto stack
            num_elements <= num_elements + 1; // Increment number of elements
        end else if (RW && num_elements > 0) begin // Pop operation
            dataOut <= stack_mem[num_elements-1]; // Pop data from stack
            stack_mem[num_elements-1] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            num_elements <= num_elements - 1; // Decrement number of elements
        end
    end
end

assign EMPTY = (num_elements == 0); // Buffer is empty when num_elements is 0
assign FULL = (num_elements == BUFFER_SIZE); // Buffer is full when num_elements is equal to BUFFER_SIZE

endmodule