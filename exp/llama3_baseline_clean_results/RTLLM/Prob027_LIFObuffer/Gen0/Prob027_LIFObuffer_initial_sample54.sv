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

// Define the stack memory array
reg [3:0] stack_mem [3:0];
reg [1:0] SP; // Stack Pointer

// Initialize the stack memory array and the stack pointer
initial begin
    for (int i = 0; i < 4; i++) begin
        stack_mem[i] = 4'b0;
    end
    SP = 4;
end

// Main logic
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] = 4'b0;
        end
        SP = 4;
    end else if (EN) begin
        if (~RW && (SP > 0)) begin
            // Push operation
            stack_mem[SP - 1] = dataIn;
            SP = SP - 1;
        end else if (RW && (SP < 4)) begin
            // Pop operation
            dataOut = stack_mem[SP];
            stack_mem[SP] = 4'b0;
            SP = SP + 1;
        end
    end
end

// Update the EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

endmodule