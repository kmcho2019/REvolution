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

reg [3:0] stack_mem [3:0];  // Stack memory array to store data
reg [1:0] SP;  // Stack pointer to track current position
reg EMPTY_reg;  // Flag to indicate if buffer is empty
reg FULL_reg;  // Flag to indicate if buffer is full
reg [3:0] dataOut_reg;  // Register to store output data

// Update flags based on stack pointer status
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(*) begin
    if (RW == 1'b0) begin
        // Push data onto stack
        dataOut_reg = 4'b0;  // Clear output data during write
    end else begin
        // Pop data from stack
        if (SP == 4) begin
            dataOut_reg = 4'b0;  // Buffer is empty, output 0
        end else begin
            dataOut_reg = stack_mem[SP];  // Assign output data from stack
        end
    end
end

always @(posedge Clk) begin
    if (EN == 1'b1) begin
        if (Rst == 1'b1) begin
            // Reset buffer, set stack pointer to 4 (empty), and clear memory
            SP <= 4;
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
        end else begin
            if (RW == 1'b0 && FULL_reg == 1'b0) begin
                // Push data onto stack, decrement stack pointer
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
            end else if (RW == 1'b1 && EMPTY_reg == 1'b0) begin
                // Pop data from stack, increment stack pointer, and clear stack memory
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
        end
    end
end

// Update output data and flags
assign dataOut = dataOut_reg;
always @(posedge Clk) begin
    if (EN == 1'b1) begin
        if (Rst == 1'b1) begin
            EMPTY_reg <= 1'b1;  // Buffer is empty after reset
            FULL_reg <= 1'b0;  // Buffer is not full after reset
        end else begin
            if (SP == 0) begin
                FULL_reg <= 1'b1;  // Buffer is full
            end else if (SP == 4) begin
                EMPTY_reg <= 1'b1;  // Buffer is empty
            end else begin
                EMPTY_reg <= 1'b0;  // Buffer is not empty
                FULL_reg <= 1'b0;  // Buffer is not full
            end
        end
    end
end

endmodule