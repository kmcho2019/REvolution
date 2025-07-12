module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [0:3];  // Stack memory array
reg [1:0] SP;             // Stack pointer
reg EMPTY_int;            // Internal EMPTY flag
reg FULL_int;             // Internal FULL flag

// Initialize stack memory and stack pointer
initial begin
    for (int i = 0; i < 4; i++) begin
        stack_mem[i] = 4'b0;
    end
    SP = 2'd4;  // Initialize stack pointer to indicate an empty buffer
    EMPTY_int = 1'b1;  // Initialize EMPTY flag
    FULL_int = 1'b0;  // Initialize FULL flag
end

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] = 4'b0;
            end
            SP = 2'd4;  // Reset stack pointer to indicate an empty buffer
            EMPTY_int = 1'b1;  // Reset EMPTY flag
            FULL_int = 1'b0;  // Reset FULL flag
        end else begin
            // Check for push (write) operation
            if (~RW && ~FULL_int) begin
                stack_mem[SP - 1] = dataIn;  // Push data onto the stack
                SP = SP - 1;                // Decrement stack pointer
                EMPTY_int = 1'b0;           // Update EMPTY flag
                if (SP == 2'd0) begin
                    FULL_int = 1'b1;         // Update FULL flag if buffer is full
                end else begin
                    FULL_int = 1'b0;
                end
            end
            
            // Check for pop (read) operation
            if (RW && ~EMPTY_int) begin
                dataOut = stack_mem[SP];     // Pop data from the stack
                stack_mem[SP] = 4'b0;          // Clear the corresponding stack memory
                SP = SP + 1;                   // Increment stack pointer
                FULL_int = 1'b0;               // Update FULL flag
                if (SP == 2'd4) begin
                    EMPTY_int = 1'b1;          // Update EMPTY flag if buffer is empty
                end else begin
                    EMPTY_int = 1'b0;
                end
            end
        end
    end
end

assign EMPTY = EMPTY_int;
assign FULL = FULL_int;

endmodule