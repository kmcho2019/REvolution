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

reg [3:0] buffer[3:0];  // Buffer to store data
reg [1:0] SP = 2'd4;   // Stack pointer, initialized to indicate an empty buffer

// Handle reset condition
always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear buffer and set stack pointer to indicate an empty buffer
        for (int i = 0; i < 4; i++) begin
            buffer[i] <= 4'd0;
        end
        SP <= 2'd4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end
end

// Handle buffer operations
always @(posedge Clk) begin
    if (~Rst && EN) begin
        if (~RW) begin
            // Write operation: Write data to the buffer
            if (SP!= 2'd0) begin
                buffer[SP - 1] <= dataIn;
                SP <= SP - 1;
            end
        end else if (RW) begin
            // Read operation: Read data from the buffer
            if (SP!= 2'd4) begin
                dataOut <= buffer[SP];
                buffer[SP] <= 4'd0; // Clear the read location
                SP <= SP + 1;
            end
        end
    end
end

// Update EMPTY and FULL flags
always @(*) begin
    EMPTY = (SP == 2'd4);
    FULL = (SP == 2'd0);
end

endmodule