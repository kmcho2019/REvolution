module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

// Stack memory array
reg [3:0] stack_mem [0:3];
// Stack pointer (2-bit register with range 0 to 3)
reg [1:0] SP;

// Initialize stack pointer and EMPTY/FULL flags
initial begin
    SP = 2'd3; // Initialize stack pointer to 3 (empty buffer)
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Update stack pointer and dataOut on clock edge
always @(posedge Clk) begin
    if (Rst) begin // Reset the buffer
        // Clear stack memory array
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        // Initialize stack pointer to 3 (empty buffer)
        SP <= 2'd3;
        // Update EMPTY/FULL flags
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin // Perform buffer operations
        if (!RW && (SP > 2'd0)) begin // Write operation (push data onto the stack)
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            // Decrement stack pointer
            SP <= SP - 1;
        end else if (RW && (SP < 2'd3)) begin // Read operation (pop data from the stack)
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            // Clear popped data from stack
            stack_mem[SP] <= 4'd0;
            // Increment stack pointer
            SP <= SP + 1;
        end
        // Update EMPTY/FULL flags using combinational logic
        EMPTY <= (SP == 2'd3);
        FULL <= (SP == 2'd0);
    end
end

endmodule