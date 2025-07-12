module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] buff_mem[3:0]; // Buffer memory
reg [1:0] HEAD;         // Head pointer
reg [1:0] TAIL;         // Tail pointer
reg [1:0] COUNT;        // Count of elements in the buffer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear buffer, set HEAD and TAIL to 0, and COUNT to 0
        for (int i = 0; i < 4; i++) begin
            buff_mem[i] <= 4'd0;
        end
        HEAD <= 2'd0;
        TAIL <= 2'd0;
        COUNT <= 2'd0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW && (COUNT < 4)) begin
            // Write operation: Push data onto the buffer
            buff_mem[TAIL] <= dataIn;
            TAIL <= (TAIL + 1) % 4; // Increment TAIL in a circular manner
            COUNT <= COUNT + 1;
        end else if (RW && (COUNT > 0)) begin
            // Read operation: Pop data from the buffer
            dataOut <= buff_mem[HEAD];
            buff_mem[HEAD] <= 4'd0;
            HEAD <= (HEAD + 1) % 4; // Increment HEAD in a circular manner
            COUNT <= COUNT - 1;
        end
        // Update EMPTY and FULL flags based on COUNT
        EMPTY <= (COUNT == 0);
        FULL <= (COUNT == 4);
    end
end

endmodule