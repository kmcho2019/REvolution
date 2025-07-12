module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

// Circular buffer memory array
reg [3:0] buffer_mem [0:3];
// Write pointer (2-bit register with range 0 to 3)
reg [1:0] WRITE_PTR;
// Read pointer (2-bit register with range 0 to 3)
reg [1:0] READ_PTR;
// Count of valid entries in the buffer
reg [1:0] entry_count;

// Initialize pointers and flags
initial begin
    WRITE_PTR = 2'd0;
    READ_PTR = 2'd0;
    entry_count = 2'd0;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Update buffer on clock edge
always @(posedge Clk) begin
    if (Rst) begin // Reset the buffer
        // Clear buffer memory array
        for (int i = 0; i < 4; i++) begin
            buffer_mem[i] <= 4'd0;
        end
        // Initialize pointers
        WRITE_PTR <= 2'd0;
        READ_PTR <= 2'd0;
        // Initialize entry count
        entry_count <= 2'd0;
        // Update EMPTY/FULL flags
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin // Perform buffer operations
        if (!RW) begin // Write operation
            if (entry_count < 2'd4) begin // Buffer not full
                // Write data to current WRITE_PTR position
                buffer_mem[WRITE_PTR] <= dataIn;
                // Increment WRITE_PTR (wrap around if necessary)
                WRITE_PTR <= (WRITE_PTR == 2'd3) ? 2'd0 : WRITE_PTR + 1;
                // Increment entry count
                entry_count <= entry_count + 1;
                // Update EMPTY flag
                EMPTY <= (entry_count == 2'd1) ? 1'b0 : EMPTY;
                // Update FULL flag
                FULL <= (entry_count == 2'd4) ? 1'b1 : FULL;
            end
        end else begin // Read operation
            if (entry_count > 2'd0) begin // Buffer not empty
                // Read data from current READ_PTR position
                dataOut <= buffer_mem[READ_PTR];
                // Clear read data from buffer
                buffer_mem[READ_PTR] <= 4'd0;
                // Increment READ_PTR (wrap around if necessary)
                READ_PTR <= (READ_PTR == 2'd3) ? 2'd0 : READ_PTR + 1;
                // Decrement entry count
                entry_count <= entry_count - 1;
                // Update EMPTY flag
                EMPTY <= (entry_count == 2'd0) ? 1'b1 : EMPTY;
                // Update FULL flag
                FULL <= (entry_count == 2'd4) ? 1'b1 : FULL;
            end
        end
    end
end

endmodule