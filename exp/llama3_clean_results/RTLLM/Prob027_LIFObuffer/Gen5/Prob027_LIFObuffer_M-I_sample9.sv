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
    output [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [BUFFER_SIZE-1:0] SP; // Stack pointer
reg clk_enable; // Clock enable signal

assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

// Clock-gating mechanism
always @(*) begin
    if (Rst) begin
        clk_enable <= 1'b0;
    end else if (EN) begin
        if (RW &&!EMPTY) begin
            clk_enable <= 1'b1;
        end else if (!RW &&!FULL) begin
            clk_enable <= 1'b1;
        end else begin
            clk_enable <= 1'b0;
        end
    end else begin
        clk_enable <= 1'b0;
    end
end

// Sequential logic for stack pointer and stack memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
    end else if (EN && clk_enable) begin // Enable signal is high and clock is enabled
        if (!RW &&!FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW &&!EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

endmodule