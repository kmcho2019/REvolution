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

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer

always @ (posedge Clk) begin
    if (Rst) begin
        // Reset the stack
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4; // Set stack pointer to 4 (indicating an empty buffer)
        EMPTY <= 1'b1; // Set EMPTY flag
        FULL <= 1'b0; // Clear FULL flag
    end else if (EN) begin
        if (RW == 1'b0 && SP > 2'd0) begin
            // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW == 1'b1 && SP < 2'd4) begin
            // Pop data from the stack (read operation)
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1'b1;
        end

        // Update EMPTY and FULL flags
        if (SP == 2'd4) begin
            EMPTY <= 1'b1; // Set EMPTY flag
            FULL <= 1'b0; // Clear FULL flag
        end else if (SP == 2'd0) begin
            EMPTY <= 1'b0; // Clear EMPTY flag
            FULL <= 1'b1; // Set FULL flag
        end else begin
            EMPTY <= 1'b0; // Clear EMPTY flag
            FULL <= 1'b0; // Clear FULL flag
        end
    end
end

endmodule