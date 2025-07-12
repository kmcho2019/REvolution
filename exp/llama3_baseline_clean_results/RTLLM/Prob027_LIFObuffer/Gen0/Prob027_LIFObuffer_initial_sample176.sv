module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [3:0]; // Stack memory array
reg [1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin // Reset condition
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize stack memory to 0
        end
        SP <= 4'b100; // Set stack pointer to 4, indicating an empty buffer
    end else if (EN) begin // Enable condition
        if (~RW && (SP != 4'b0)) begin // Write operation and buffer not full
            stack_mem[SP-1] <= dataIn; // Push data onto the stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && (SP != 4)) begin // Read operation and buffer not empty
            dataOut <= stack_mem[SP]; // Pop data from the stack
            stack_mem[SP] <= 4'b0; // Clear the popped memory location
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

assign EMPTY = (SP == 4); // Buffer is empty when stack pointer is 4
assign FULL = (SP == 0); // Buffer is full when stack pointer is 0

endmodule