module LIFObuffer(
    input   logic           Clk,       // Clock signal
    input   logic           Rst,       // Active high reset signal
    input   logic           EN,        // Enable signal
    input   logic           RW,        // Read/Write control signal (1 for read, 0 for write)
    input   logic [3:0]     dataIn,    // 4-bit input data
    output  logic           EMPTY,     // Flag indicating whether the buffer is empty
    output  logic           FULL,      // Flag indicating whether the buffer is full
    output  logic [3:0]     dataOut    // 4-bit output data
);

// Stack memory declaration
logic [3:0] stack_mem [3:0];

// Stack pointer declaration
logic [1:0] SP;

// Internal signal for dataOut
logic [3:0] dataOut_int;

// Initialize the stack pointer and flags
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack pointer and flags
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        
        // Initialize the stack memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        // Check if the buffer is full or empty
        if (RW == 1'b0 && SP!= 0) begin
            // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1'b1 && SP!= 4) begin
            // Pop data from the stack (read operation)
            dataOut_int <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
        
        // Update the EMPTY and FULL flags
        if (SP == 4) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (SP == 0) begin
            EMPTY <= 1'b0;
            FULL <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
            FULL <= 1'b0;
        end
    end
end

// Assign the output data
assign dataOut = (RW == 1'b1 && SP!= 4)? dataOut_int : 4'b0;

// Assign the EMPTY and FULL flags
assign EMPTY = (SP == 4)? 1'b1 : 1'b0;
assign FULL = (SP == 0)? 1'b1 : 1'b0;

endmodule