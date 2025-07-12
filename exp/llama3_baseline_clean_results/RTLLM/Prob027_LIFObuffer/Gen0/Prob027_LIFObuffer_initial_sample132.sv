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

reg [3:0] stack_mem [0:3]; // stack memory array
reg [1:0] SP; // stack pointer

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Clear the stack and reset the stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 2'd4; // Initialize SP to 4 (indicating an empty buffer)
            EMPTY <= 1'b1; // Set EMPTY flag to 1
            FULL <= 1'b0; // Set FULL flag to 0
        end else begin
            // Check if the buffer is full or empty
            if (RW == 1'b0 && SP != 2'd0) begin
                // Write operation: push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end else if (RW == 1'b1 && SP != 2'd4) begin
                // Read operation: pop data from the stack
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0; // Clear the popped data
                SP <= SP + 1;
            end
            // Update EMPTY and FULL flags
            if (SP == 2'd4) begin
                EMPTY <= 1'b1; // Set EMPTY flag to 1
                FULL <= 1'b0; // Set FULL flag to 0
            end else if (SP == 2'd0) begin
                EMPTY <= 1'b0; // Set EMPTY flag to 0
                FULL <= 1'b1; // Set FULL flag to 1
            end else begin
                EMPTY <= 1'b0; // Set EMPTY flag to 0
                FULL <= 1'b0; // Set FULL flag to 0
            end
        end
    end
end

endmodule