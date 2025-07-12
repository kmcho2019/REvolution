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
reg [2:0] SP; // Stack pointer, optimized bit width
reg [DATA_WIDTH-1:0] temp_dataOut; // Temporary data out for combinational logic

// Combinational logic for EMPTY and FULL flags, simplified
assign EMPTY = (SP == BUFFER_SIZE);
assign FULL = (SP == 0);

// Combinational logic for data out, depending on RW and SP
always_comb begin
    if (RW && !EMPTY) begin
        temp_dataOut = stack_mem[SP];
    end else begin
        temp_dataOut = {DATA_WIDTH{1'b0}};
    end
end

// Sequential logic for stack pointer and stack memory, optimized for PPA
always @(posedge Clk) begin
    if (Rst) begin // Active high reset, optimized for low power
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0, minimizing switching
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high, gated for low power
        if (!RW && SP > 0 && !FULL) begin // Push operation, optimized for performance
            stack_mem[SP-1] <= dataIn; // Push data onto stack, minimizing switching
            SP <= SP - 1; // Decrement stack pointer, optimized for area
        end else if (RW && SP < BUFFER_SIZE && !EMPTY) begin // Pop operation, optimized for performance
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data, optimizing for power
            SP <= SP + 1; // Increment stack pointer, optimized for area
        end
        dataOut <= temp_dataOut; // Update data out
    end
end

endmodule