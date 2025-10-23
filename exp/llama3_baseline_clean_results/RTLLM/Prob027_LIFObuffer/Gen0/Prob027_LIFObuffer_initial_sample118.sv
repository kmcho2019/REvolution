module LIFObuffer(
    input [3:0] dataIn,    // 4-bit input data
    input RW,             // Read/Write control signal (1 for read, 0 for write)
    input EN,             // Enable signal to activate buffer operations
    input Rst,            // Active high reset signal to initialize the buffer
    input Clk,            // Clock signal for synchronous operations
    output EMPTY,         // Flag indicating whether the buffer is empty
    output FULL,          // Flag indicating whether the buffer is full
    output [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP;            // Stack pointer

// Initialize EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// Update dataOut
assign dataOut = stack_mem[SP];

always @(posedge Clk) begin
    if (Rst) begin
        // Clear stack and reset stack pointer on reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        case (RW)
            1'b0: begin // Write operation
                if (!FULL) begin
                    stack_mem[SP - 1] <= dataIn;
                    SP <= SP - 1;
                end
            end
            1'b1: begin // Read operation
                if (!EMPTY) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1;
                end
            end
        endcase
    end
end

endmodule