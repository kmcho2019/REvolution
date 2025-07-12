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

reg [3:0] stack_mem [3:0];
reg [1:0] SP;
reg EMPTY_reg;
reg FULL_reg;

always @ (posedge Clk) begin
    if (Rst) begin
        // Reset the stack pointer and memory
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (EN) begin
        // Check if the buffer is full or empty and process data accordingly
        if (!RW &&!FULL_reg) begin
            // Write operation: push data onto the stack and decrement the stack pointer
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            EMPTY_reg <= 1'b0;
        end else if (RW &&!EMPTY_reg) begin
            // Read operation: pop data from the stack, clear the corresponding stack memory, and increment the stack pointer
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
            FULL_reg <= 1'b0;
        end
        // Update the EMPTY and FULL flags
        if (SP == 4) begin
            EMPTY_reg <= 1'b1;
        end else if (SP == 0) begin
            FULL_reg <= 1'b1;
        end else begin
            EMPTY_reg <= 1'b0;
            FULL_reg <= 1'b0;
        end
    end
end

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;

endmodule