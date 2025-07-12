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

// Define the stack memory
reg [3:0] stack_mem [3:0];

// Define the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Update flags based on the stack pointer
always @(posedge Clk) begin
    if (Rst) begin
        EMPTY = 1'b1;
        FULL = 1'b0;
    end else if (EN) begin
        if (RW == 1'b0 && SP!= 0) begin // Write operation
            EMPTY = 1'b0;
            if (SP == 1) begin
                FULL = 1'b1;
            end
        end else if (RW == 1'b1 && SP!= 4) begin // Read operation
            FULL = 1'b0;
            if (SP == 3) begin
                EMPTY = 1'b1;
            end
        end
    end
end

// Perform push and pop operations on the rising edge of the clock
always @(posedge Clk) begin
    if (Rst) begin
        // Clear the stack and initialize the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] = 4'b0;
        end
        SP = 4;
    end else if (EN) begin
        if (RW == 1'b0 && SP!= 0) begin // Push operation
            // Push data onto the stack
            stack_mem[SP - 1] = dataIn;
            // Decrement the stack pointer
            SP = SP - 1;
        end else if (RW == 1'b1 && SP!= 4) begin // Pop operation
            // Pop data from the stack
            dataOut = stack_mem[SP];
            // Clear the corresponding stack memory
            stack_mem[SP] = 4'b0;
            // Increment the stack pointer
            SP = SP + 1;
        end
    end
end

// Assign dataOut based on the stack pointer
assign dataOut = (RW == 1'b1 && SP!= 4)? stack_mem[SP] : 4'b0;

// Update EMPTY and FULL flags based on the stack pointer
assign EMPTY = (SP == 4)? 1'b1 : 1'b0;
assign FULL = (SP == 0)? 1'b1 : 1'b0;

endmodule