module LIFObuffer(
    input  [3:0] dataIn,
    input        RW,
    input        EN,
    input        Rst,
    input        Clk,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

    logic [3:0] stack_mem[4];  // Stack memory array
    logic [1:0] SP;            // Stack pointer
    logic [3:0] temp_dataOut;  // Temporary output data

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset operation
            SP <= 4;  // Initialize stack pointer to 4
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;  // Initialize all memory locations to 0
            end
        end else if (EN) begin
            // Enable buffer operations
            if (!RW && (SP != 0)) begin
                // Write operation (push data onto the stack)
                stack_mem[SP-1] <= dataIn;  // Push data onto the stack
                SP <= SP - 1;  // Decrement the stack pointer
            end else if (RW && (SP != 4)) begin
                // Read operation (pop data from the stack)
                temp_dataOut <= stack_mem[SP];  // Pop data from the stack
                stack_mem[SP] <= 4'd0;  // Clear the corresponding stack memory
                SP <= SP + 1;  // Increment the stack pointer
            end
        end
    end

    always_comb begin
        // Update EMPTY and FULL flags
        if (SP == 4) begin
            EMPTY = 1'b1;  // Buffer is empty
            FULL = 1'b0;   // Buffer is not full
        end else if (SP == 0) begin
            EMPTY = 1'b0;  // Buffer is not empty
            FULL = 1'b1;   // Buffer is full
        end else begin
            EMPTY = 1'b0;  // Buffer is not empty
            FULL = 1'b0;   // Buffer is not full
        end

        // Update dataOut
        if (RW && (SP != 4)) begin
            dataOut <= temp_dataOut;  // Update dataOut when reading from the stack
        end else begin
            dataOut <= 4'd0;  // Clear dataOut when not reading from the stack
        end
    end

endmodule