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
reg [1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 2'd0; // Initialize stack pointer to 0 (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
        EMPTY <= 1'b1; // Initialize EMPTY flag
        FULL <= 1'b0; // Initialize FULL flag
    end else if (EN) begin // Enable signal is high
        if (!RW && SP < 2'd3) begin // Push operation
            stack_mem[SP] <= dataIn; // Push data onto stack
            SP <= SP + 1; // Increment stack pointer
            EMPTY <= 1'b0; // Update EMPTY flag
            if (SP == 2'd3) begin
                FULL <= 1'b1; // Update FULL flag
            end else begin
                FULL <= 1'b0; // Update FULL flag
            end
        end else if (RW && SP > 2'd0) begin // Pop operation
            dataOut <= stack_mem[SP-1]; // Pop data from stack
            stack_mem[SP-1] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP - 1; // Decrement stack pointer
            FULL <= 1'b0; // Update FULL flag
            if (SP == 2'd0) begin
                EMPTY <= 1'b1; // Update EMPTY flag
            end else begin
                EMPTY <= 1'b0; // Update EMPTY flag
            end
        end
    end
end

endmodule