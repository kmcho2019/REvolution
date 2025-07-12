module LIFObuffer(
    input logic Clk, 
    input logic Rst, 
    input logic EN, 
    input logic RW, 
    input logic [3:0] dataIn, 
    output logic EMPTY, 
    output logic FULL, 
    output logic [3:0] dataOut
);

// Define the stack memory array
logic [3:0] stack_mem [0:3];

// Define the stack pointer
logic [1:0] SP;

// Initialize the stack pointer and flags
always_ff @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack pointer and clear the stack memory
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        // Check for write operation
        if (~RW && SP > 0) begin
            // Push data onto the stack and decrement the stack pointer
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end 
        // Check for read operation
        else if (RW && SP < 4) begin
            // Pop data from the stack, clear the corresponding memory, and increment the stack pointer
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

// Update the EMPTY and FULL flags
always_comb begin
    if (SP == 4) begin
        EMPTY = 1'b1;
        FULL = 1'b0;
    end else if (SP == 0) begin
        EMPTY = 1'b0;
        FULL = 1'b1;
    end else begin
        EMPTY = 1'b0;
        FULL = 1'b0;
    end
end

endmodule