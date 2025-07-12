module LIFObuffer (
    input   logic           Clk,
    input   logic           Rst,
    input   logic           EN,
    input   logic           RW,
    input   logic [3:0]     dataIn,
    output  logic           EMPTY,
    output  logic           FULL,
    output  logic [3:0]     dataOut
);

    logic [3:0]     stack_mem [3:0];  // 4-entry stack memory array
    logic [1:0]     SP;              // Stack Pointer (0-3)

    always_ff @(posedge Clk) begin
        if (Rst) begin  // Reset
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;  // Initialize stack memory to 0
            end
            SP <= 2'b11;  // Set stack pointer to 3 (empty buffer)
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (EN) begin  // Enable signal is high
            if (RW) begin  // Read operation
                if (SP != 2'b11) begin  // Buffer is not empty
                    dataOut <= stack_mem[SP];  // Pop data from the stack
                    stack_mem[SP] <= 4'b0;     // Clear the popped data
                    SP <= SP + 1'b1;           // Decrement stack pointer
                    EMPTY <= (SP == 2'b11) ? 1'b1 : 1'b0;  // Update EMPTY flag
                    FULL <= (SP == 2'b11) ? 1'b0 : 1'b0;
                end
            end else begin  // Write operation
                if (SP != 2'b00) begin  // Buffer is not full
                    SP <= SP - 1'b1;           // Increment stack pointer
                    stack_mem[SP] <= dataIn;    // Push data onto the stack
                    EMPTY <= (SP == 2'b11) ? 1'b1 : 1'b0;  // Update EMPTY flag
                    FULL <= (SP == 2'b00) ? 1'b1 : 1'b0;  // Update FULL flag
                end
            end
        end
    end

    assign EMPTY = (SP == 2'b11) ? 1'b1 : 1'b0;
    assign FULL  = (SP == 2'b00) ? 1'b1 : 1'b0;

endmodule