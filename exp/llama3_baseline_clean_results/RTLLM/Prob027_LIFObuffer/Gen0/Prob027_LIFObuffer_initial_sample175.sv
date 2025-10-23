module LIFObuffer(
    input logic [3:0] dataIn,
    input logic RW, 
    input logic EN, 
    input logic Rst, 
    input logic Clk,
    output logic EMPTY, 
    output logic FULL, 
    output logic [3:0] dataOut
);

logic [3:0] stack_mem [0:3]; // Stack memory array to store the data
logic [1:0] SP; // Stack pointer to track the current position in the stack

// Reset logic to initialize the stack and reset the stack pointer
always_ff @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize all memory locations to 0
        end
        SP <= 2'd4; // Set the stack pointer to 4 (indicating an empty buffer)
    end
    // Buffer operations when the enable signal is high
    else if (EN) begin
        if (~RW && (SP != 2'd0)) begin // Write operation when the buffer is not full
            stack_mem[SP - 1] <= dataIn; // Push data onto the stack
            SP <= SP - 1'b1; // Decrement the stack pointer
        end
        else if (RW && (SP != 2'd4)) begin // Read operation when the buffer is not empty
            dataOut <= stack_mem[SP]; // Pop data from the stack into dataOut
            stack_mem[SP] <= 4'b0; // Clear the corresponding stack memory
            SP <= SP + 1'b1; // Increment the stack pointer
        end
    end
end

// Update the EMPTY and FULL flags based on the stack pointer status
always_comb begin
    EMPTY = (SP == 2'd4); // Buffer is empty when the stack pointer is 4
    FULL = (SP == 2'd0); // Buffer is full when the stack pointer is 0
end

endmodule