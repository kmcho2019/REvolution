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

reg [3:0] stack_mem [0:3]; // 4-entry stack memory array
reg [1:0] SP; // Stack pointer (0-3)
reg [3:0] dataOut_reg; // Register for output data

assign EMPTY = (SP == 3); // Buffer is empty when SP is 3
assign FULL = (SP == 0); // Buffer is full when SP is 0
assign dataOut = dataOut_reg; // Assign dataOut_reg to output port dataOut

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 3; // Initialize stack pointer to 3 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize stack memory to 0
        end
        dataOut_reg <= 4'b0; // Reset dataOut_reg
    end else if (EN) begin // Enable signal is high
        case ({RW, FULL, EMPTY})
            3'b010: begin // RW is low (write) and buffer is not full
                stack_mem[SP-1] <= dataIn; // Push data onto stack
                SP <= SP - 1; // Decrement stack pointer
            end
            3'b101: begin // RW is high (read) and buffer is not empty
                dataOut_reg <= stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= 4'b0; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
            end
            default: begin // No operation or invalid state
                // No change to SP, stack_mem, or dataOut_reg
            end
        endcase
    end
end

endmodule