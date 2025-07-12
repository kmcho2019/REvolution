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
reg [1:0] WP;           // Write pointer
reg [1:0] RP;           // Read pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear buffer and set WP and RP to 0
        for (int i = 0; i < 4; i++) begin
            buffer[i] <= 4'd0;
        end
        WP <= 2'd0;
        RP <= 2'd0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW) begin
            // Write operation: Write data to the buffer
            buffer[WP] <= dataIn;
            WP <= (WP + 1) % 4; // Increment WP with wrap-around
        end else if (RW) begin
            // Read operation: Read data from the buffer
            dataOut <= buffer[RP];
            RP <= (RP + 1) % 4; // Increment RP with wrap-around
        end
        // Update EMPTY and FULL flags
        if (WP == RP) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if ((WP + 1) % 4 == RP) begin
            FULL <= 1'b1;
            EMPTY <= 1'b0;
        end else begin
            EMPTY <= 1'b0;
            FULL <= 1'b0;
        end
    end
end

endmodule