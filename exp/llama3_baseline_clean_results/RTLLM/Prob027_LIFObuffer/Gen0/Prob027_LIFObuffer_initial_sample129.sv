module LIFObuffer(
    input dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin // Reset operation
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Clear stack memory
        end
        SP <= 2'd4; // Initialize stack pointer to 4 (empty buffer)
        EMPTY <= 1'b1; // Set EMPTY flag high
        FULL <= 1'b0; // Set FULL flag low
    end else if (EN) begin // Enable buffer operations
        if (~RW && SP!= 4'd0) begin // Write operation (push)
            stack_mem[SP - 1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
            if (SP == 2'd0) begin // Check if buffer is full
                FULL <= 1'b1;
            end else begin
                FULL <= 1'b0;
            end
            EMPTY <= 1'b0; // Set EMPTY flag low
        end else if (RW && SP!= 4'd4) begin // Read operation (pop)
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= 4'd0; // Clear popped memory location
            SP <= SP + 1; // Increment stack pointer
            if (SP == 2'd4) begin // Check if buffer is empty
                EMPTY <= 1'b1;
            end else begin
                EMPTY <= 1'b0;
            end
            FULL <= 1'b0; // Set FULL flag low
        end
    end
end

endmodule