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

reg [3:0] stack_mem [0:3]; // Stack memory to store data entries
reg [1:0] SP; // Stack pointer
reg EMPTY_reg; // Register for EMPTY flag
reg FULL_reg; // Register for FULL flag
reg [3:0] dataOut_reg; // Register for output data

// Initialize EMPTY and FULL flags based on the stack pointer
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// Assign output data
assign dataOut = dataOut_reg;

always @ (posedge Clk) begin
    if (Rst) begin
        // Reset the stack and initialize the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Clear stack memory
        end
        SP <= 2'd4; // Set stack pointer to 4, indicating an empty buffer
        dataOut_reg <= 4'd0; // Clear output data
        EMPTY_reg <= 1'b1; // Set EMPTY flag
        FULL_reg <= 1'b0; // Clear FULL flag
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Write operation: Push data onto the stack and decrement the stack pointer
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
            dataOut_reg <= 4'd0; // Clear output data
        end else if (RW && ~EMPTY) begin
            // Read operation: Pop data from the stack, clear the corresponding stack memory, and increment the stack pointer
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'd0; // Clear the popped data
            SP <= SP + 1'b1;
        end
    end
end

endmodule