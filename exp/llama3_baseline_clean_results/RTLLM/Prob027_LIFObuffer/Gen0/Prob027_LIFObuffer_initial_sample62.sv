module LIFObuffer(
    input  logic [3:0] dataIn,
    input  logic       RW,
    input  logic       EN,
    input  logic       Rst,
    input  logic       Clk,
    output logic       EMPTY,
    output logic       FULL,
    output logic [3:0] dataOut
);

    // Define the stack memory and stack pointer
    logic [3:0] stack_mem [0:3];
    logic [1:0] SP;

    always_ff @(posedge Clk) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 2'b11; // Set SP to 4 (binary 100) to indicate an empty buffer, but in 2 bits it represents the number of elements in the buffer
        end else if (EN) begin
            if (!RW && (SP != 2'b00)) begin // Write operation and buffer is not full
                stack_mem[SP - 1] <= dataIn; // Push data onto the stack
                SP <= SP - 1'b1; // Decrement stack pointer
            end else if (RW && (SP != 2'b11)) begin // Read operation and buffer is not empty
                dataOut <= stack_mem[SP]; // Pop data from the stack
                stack_mem[SP] <= 4'b0; // Clear the corresponding stack memory
                SP <= SP + 1'b1; // Increment stack pointer
            end
        end
    end

    // Update flags for EMPTY and FULL based on stack pointer status
    assign EMPTY = (SP == 2'b11);
    assign FULL = (SP == 2'b00);

endmodule