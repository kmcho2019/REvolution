module LIFObuffer (
    input [3:0] dataIn, // 4-bit input data
    input RW, // Read/Write control signal
    input EN, // Enable signal
    input Rst, // Active high reset signal
    input Clk, // Clock signal
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg EMPTY_reg; // Register for EMPTY flag
reg FULL_reg; // Register for FULL flag
reg [3:0] dataOut_reg; // Register for output data

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 2'd4; // Initialize stack pointer to 4 (empty buffer)
            EMPTY_reg <= 1'b1; // Set EMPTY flag
            FULL_reg <= 1'b0; // Clear FULL flag
        end else begin
            // Check if buffer is full or empty
            if (~FULL_reg && ~RW) begin
                // Write operation
                stack_mem[SP] <= dataIn; // Push data onto the stack
                SP <= SP - 1; // Decrement stack pointer
                if (SP == 2'd0) begin
                    FULL_reg <= 1'b1; // Set FULL flag
                end
                EMPTY_reg <= 1'b0; // Clear EMPTY flag
            end else if (~EMPTY_reg && RW) begin
                // Read operation
                dataOut_reg <= stack_mem[SP + 1]; // Pop data from the stack
                stack_mem[SP + 1] <= 4'd0; // Clear corresponding stack memory
                SP <= SP + 1; // Increment stack pointer
                if (SP == 2'd4) begin
                    EMPTY_reg <= 1'b1; // Set EMPTY flag
                end
                FULL_reg <= 1'b0; // Clear FULL flag
            end
        end
    end
end

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule