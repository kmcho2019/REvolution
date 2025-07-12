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
reg [2:0] next_SP; // Next stack pointer value
reg clk_gated; // Clock gated signal

// Clock gating
always @(posedge Clk) begin
    if (EN) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Combinational logic for EMPTY and FULL flags
always @(posedge Clk) begin
    if (Rst) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else begin
        if (SP == BUFFER_SIZE) begin
            EMPTY <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
        end
        
        if (SP == 0) begin
            FULL <= 1'b1;
        end else begin
            FULL <= 1'b0;
        end
    end
end

// Sequential logic for stack pointer and stack memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN && clk_gated) begin // Enable signal is high and clock is gated
        if (!RW && SP > 0 && !FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            next_SP <= SP - 1; // Decrement stack pointer
        end else if (RW && SP < BUFFER_SIZE && !EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            next_SP <= SP + 1; // Increment stack pointer
        end else begin
            next_SP <= SP; // No change in stack pointer
        end
    end
end

// Update stack pointer
always @(posedge Clk) begin
    SP <= next_SP;
end

endmodule