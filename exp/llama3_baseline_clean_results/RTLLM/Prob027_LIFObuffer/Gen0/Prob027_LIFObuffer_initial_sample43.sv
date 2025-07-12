module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data
    input RW, // Read/Write control signal
    input EN, // Enable signal
    input Rst, // Active high reset signal
    input Clk, // Clock signal
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data
);

reg [3:0] stack_mem [3:0]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg [3:0] temp_data; // Temporary data for output

// Initialize stack memory and stack pointer
always @(posedge Clk) begin
    if (Rst) begin
        // Clear stack memory and set stack pointer to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4;
    end
    else if (EN) begin
        // Check if buffer is full or empty
        if (RW == 0 && SP!= 0) begin
            // Write operation: push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end
        else if (RW == 1 && SP!= 4) begin
            // Read operation: pop data from the stack
            temp_data <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

// Update EMPTY and FULL flags
always @(posedge Clk) begin
    if (Rst) begin
        EMPTY <= 1'b1; // Buffer is empty after reset
        FULL <= 1'b0; // Buffer is not full after reset
    end
    else if (EN) begin
        if (SP == 4) begin
            EMPTY <= 1'b1; // Buffer is empty
            FULL <= 1'b0; // Buffer is not full
        end
        else if (SP == 0) begin
            EMPTY <= 1'b0; // Buffer is not empty
            FULL <= 1'b1; // Buffer is full
        end
        else begin
            EMPTY <= 1'b0; // Buffer is not empty
            FULL <= 1'b0; // Buffer is not full
        end
    end
end

// Assign output data
assign dataOut = (RW == 1 && EN == 1)? temp_data : 4'b0;

endmodule