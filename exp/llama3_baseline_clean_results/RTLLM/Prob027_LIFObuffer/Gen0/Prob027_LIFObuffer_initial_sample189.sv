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

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg [3:0] temp_dataOut; // Temporary output data
reg temp_EMPTY; // Temporary EMPTY flag
reg temp_FULL; // Temporary FULL flag

assign dataOut = temp_dataOut;
assign EMPTY = temp_EMPTY;
assign FULL = temp_FULL;

always @ (posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 4; // Initialize stack pointer to 4 (empty buffer)
        temp_EMPTY <= 1'b1; // Set EMPTY flag
        temp_FULL <= 1'b0; // Clear FULL flag
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize stack memory to 0
        end
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (SP != 4) begin // Buffer is not empty
                temp_dataOut <= stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= 4'b0; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
                temp_EMPTY <= (SP == 4) ? 1'b1 : 1'b0; // Update EMPTY flag
                temp_FULL <= 1'b0; // Clear FULL flag
            end else begin
                temp_dataOut <= 4'b0; // Default dataOut if buffer is empty
                temp_EMPTY <= 1'b1; // Set EMPTY flag
                temp_FULL <= 1'b0; // Clear FULL flag
            end
        end else begin // Write operation
            if (SP != 0) begin // Buffer is not full
                SP <= SP - 1; // Decrement stack pointer
                stack_mem[SP] <= dataIn; // Push data onto stack
                temp_EMPTY <= (SP == 4) ? 1'b1 : 1'b0; // Update EMPTY flag
                temp_FULL <= (SP == 0) ? 1'b1 : 1'b0; // Update FULL flag
            end else begin
                temp_EMPTY <= 1'b0; // Clear EMPTY flag
                temp_FULL <= 1'b1; // Set FULL flag
            end
        end
    end
end

endmodule