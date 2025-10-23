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

logic [3:0] stack_mem [0:3]; // 4x4 stack memory array
logic [1:0] SP; // 2-bit stack pointer (0 to 3)
logic [3:0] temp_dataOut; // temporary output data

// Initialize stack pointer and flags
always @(posedge Clk) begin
    if (Rst) begin // Reset condition
        SP <= 4'b100; // Set SP to 4, indicating an empty buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0000; // Initialize all memory locations to 0
        end
        EMPTY <= 1'b1; // Set EMPTY flag high
        FULL <= 1'b0; // Set FULL flag low
    end else if (EN) begin // Enable buffer operations
        if (~RW) begin // Write operation (push)
            if (~FULL) begin // Check if buffer is not full
                stack_mem[SP - 1] <= dataIn; // Push data onto the stack
                SP <= SP - 1; // Decrement stack pointer
            end
        end else begin // Read operation (pop)
            if (~EMPTY) begin // Check if buffer is not empty
                temp_dataOut <= stack_mem[SP]; // Pop data from the stack
                stack_mem[SP] <= 4'b0000; // Clear the corresponding stack memory
                SP <= SP + 1; // Increment stack pointer
            end
        end
        // Update flags
        if (SP == 4) begin
            EMPTY <= 1'b1; // Set EMPTY flag high if SP is 4
            FULL <= 1'b0; // Set FULL flag low
        end else if (SP == 0) begin
            EMPTY <= 1'b0; // Set EMPTY flag low if SP is 0
            FULL <= 1'b1; // Set FULL flag high
        end else begin
            EMPTY <= 1'b0; // Set EMPTY flag low
            FULL <= 1'b0; // Set FULL flag low
        end
    end
end

// Assign output data
assign dataOut = temp_dataOut;

// Assign EMPTY and FULL flags
assign EMPTY = (SP == 4) ? 1'b1 : 1'b0;
assign FULL = (SP == 0) ? 1'b1 : 1'b0;

endmodule