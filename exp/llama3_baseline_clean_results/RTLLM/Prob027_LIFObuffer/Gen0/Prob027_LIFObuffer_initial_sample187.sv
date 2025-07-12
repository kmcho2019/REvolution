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

reg [3:0] stack_mem [0:3]; // Stack memory to store data
reg [1:0] SP; // Stack pointer to track current position
reg [3:0] dataOut_reg; // Register to hold output data

assign EMPTY = (SP == 4); // Buffer is empty when SP is 4
assign FULL = (SP == 0); // Buffer is full when SP is 0

always @(posedge Clk) begin
    if (Rst) begin // Reset condition
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Clear stack memory
        end
        SP <= 4; // Reset SP to indicate empty buffer
    end else if (EN) begin // Enable condition
        if (!RW && !FULL) begin // Write operation and buffer is not full
            stack_mem[SP - 1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement SP
        end else if (RW && !EMPTY) begin // Read operation and buffer is not empty
            dataOut_reg <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= 4'b0; // Clear popped data
            SP <= SP + 1; // Increment SP
        end
    end
end

assign dataOut = dataOut_reg; // Assign output data

endmodule