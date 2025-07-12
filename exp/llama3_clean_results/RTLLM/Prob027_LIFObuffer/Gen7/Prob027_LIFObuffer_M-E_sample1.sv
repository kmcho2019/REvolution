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
reg [1:0] HP;           // Head pointer for writing
reg [1:0] TP;           // Tail pointer for reading
reg [1:0] count;        // Counter for the number of elements in the buffer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear buffer, reset pointers, and set count to 0
        for (int i = 0; i < 4; i++) begin
            buffer[i] <= 4'd0;
        end
        HP <= 2'd0;
        TP <= 2'd0;
        count <= 2'd0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW) begin
            // Write operation: Write data to the buffer
            if (~FULL) begin
                buffer[HP] <= dataIn;
                HP <= (HP + 1) % 4; // Increment HP with wrap-around
                count <= count + 1;
            end
        end else if (RW) begin
            // Read operation: Read data from the buffer
            if (~EMPTY) begin
                dataOut <= buffer[TP];
                buffer[TP] <= 4'd0; // Clear the read location
                TP <= (TP + 1) % 4; // Increment TP with wrap-around
                count <= count - 1;
            end
        end
        // Update EMPTY and FULL flags
        if (count == 0) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (count == 4) begin
            FULL <= 1'b1;
            EMPTY <= 1'b0;
        end else begin
            EMPTY <= 1'b0;
            FULL <= 1'b0;
        end
    end
end

endmodule