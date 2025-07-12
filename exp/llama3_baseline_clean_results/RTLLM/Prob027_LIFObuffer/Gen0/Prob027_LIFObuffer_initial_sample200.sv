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

// Define the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack pointer and flags
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        // Initialize the stack memory array
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        // Update the flags based on the stack pointer status
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

        // Perform push or pop operations
        if (RW == 1'b0 && SP!= 0) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1'b1 && SP!= 4) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign dataOut = (RW == 1'b1 && SP!= 4)? stack_mem[SP] : 4'b0;

// Assign the flags to output ports
assign EMPTY = (SP == 4)? 1'b1 : 1'b0;
assign FULL = (SP == 0)? 1'b1 : 1'b0;

endmodule