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

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [2:0] SP; // Stack pointer
reg [DATA_WIDTH-1:0] data_out_temp; // Temporary data out

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

// Sequential logic for stack pointer and stack memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (!EMPTY) begin // Buffer is not empty
                data_out_temp = stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
            end else begin
                data_out_temp = {DATA_WIDTH{1'b0}};
            end
        end else begin // Write operation
            if (!FULL) begin // Buffer is not full
                stack_mem[SP-1] <= dataIn; // Push data onto stack
                SP <= SP - 1; // Decrement stack pointer
                data_out_temp = {DATA_WIDTH{1'b0}};
            end else begin
                data_out_temp = {DATA_WIDTH{1'b0}};
            end
        end
        dataOut <= data_out_temp; // Update data out
    end
end

endmodule