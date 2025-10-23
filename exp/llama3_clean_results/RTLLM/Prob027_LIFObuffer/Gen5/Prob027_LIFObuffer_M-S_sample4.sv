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
reg [1:0] SP;            // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear buffer, set SP to 3 (indicating an empty buffer), and initialize flags
        for (int i = 0; i < 4; i++) begin
            buff_mem[i] <= 4'd0;
        end
        SP <= 2'd3;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW && (SP > 0)) begin
            // Write operation: Push data onto the buffer
            buff_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP < 3)) begin
            // Read operation: Pop data from the buffer
            dataOut <= buff_mem[SP];
            buff_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
        // Update EMPTY and FULL flags based on SP
        EMPTY <= (SP == 3);
        FULL <= (SP == 0);
    end
end

endmodule