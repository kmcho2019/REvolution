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
reg [1:0] SP; // Simplified stack pointer (2 bits for 4-entry buffer)

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 2'b11; // Initialize stack pointer to 3 (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && SP < 3) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

// Simplified logic for EMPTY and FULL flags
assign EMPTY = (SP == 2'b11);
assign FULL = (SP == 2'b00);

endmodule