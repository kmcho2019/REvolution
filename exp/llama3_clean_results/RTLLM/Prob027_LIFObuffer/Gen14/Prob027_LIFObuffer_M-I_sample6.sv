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
reg [1:0] SP; // Compact stack pointer representation

// Combinational logic for EMPTY and FULL flags, simplified
assign EMPTY = (SP == 2'b11); // EMPTY when SP is 3 (BUFFER_SIZE)
assign FULL = (SP == 2'b00); // FULL when SP is 0

// Pipeline stage 1: Determine operation and update stack pointer
reg [1:0] next_SP;
reg [DATA_WIDTH-1:0] next_dataOut;

always @(posedge Clk) begin
    if (Rst) begin // Active high reset, optimized for low power
        SP <= 2'b11; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0, minimizing switching
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high, gated for low power
        if (!RW && SP > 2'b00 &&!FULL) begin // Push operation, optimized for performance
            next_SP <= SP - 1; // Decrement stack pointer, optimized for area
            next_dataOut <= {DATA_WIDTH{1'b0}};
        end else if (RW && SP < 2'b11 &&!EMPTY) begin // Pop operation, optimized for performance
            next_SP <= SP + 1; // Increment stack pointer, optimized for area
            next_dataOut <= stack_mem[SP];
        end else begin
            next_SP <= SP;
            next_dataOut <= dataOut;
        end
    end else begin
        next_SP <= SP;
        next_dataOut <= dataOut;
    end
end

// Pipeline stage 2: Update stack memory and output
always @(posedge Clk) begin
    if (Rst) begin // Active high reset, optimized for low power
        // No action needed in this stage during reset
    end else if (EN) begin // Enable signal is high, gated for low power
        if (!RW && next_SP > 2'b00 &&!FULL) begin // Push operation, optimized for performance
            stack_mem[next_SP] <= dataIn; // Push data onto stack, minimizing switching
        end else if (RW && next_SP < 2'b11 &&!EMPTY) begin // Pop operation, optimized for performance
            stack_mem[next_SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data, optimizing for power
        end
        SP <= next_SP;
        dataOut <= next_dataOut;
    end else begin
        // No action needed in this stage when enable is low
    end
end

endmodule