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

reg [3:0] buffer_mem[3:0]; // 4-entry deep, 4-bit wide buffer memory
reg [1:0] write_ptr;      // Pointer for write operations
reg [1:0] read_ptr;       // Pointer for read operations
reg [1:0] count;          // Counter for the number of entries in the buffer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear buffer, reset pointers, and set count to 0
        for (int i = 0; i < 4; i++) begin
            buffer_mem[i] <= 4'd0;
        end
        write_ptr <= 2'd0;
        read_ptr <= 2'd0;
        count <= 2'd0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW && (count < 4)) begin
            // Write operation: Write data into the buffer at write_ptr
            buffer_mem[write_ptr] <= dataIn;
            write_ptr <= (write_ptr + 1) % 4; // Increment write_ptr modulo 4
            count <= count + 1;
        end else if (RW && (count > 0)) begin
            // Read operation: Read data from the buffer at read_ptr
            dataOut <= buffer_mem[read_ptr];
            buffer_mem[read_ptr] <= 4'd0;
            read_ptr <= (read_ptr + 1) % 4; // Increment read_ptr modulo 4
            count <= count - 1;
        end
        // Update EMPTY and FULL flags based on count
        EMPTY <= (count == 0);
        FULL <= (count == 4);
    end
end

endmodule