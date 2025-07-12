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

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer

always @ (posedge Clk) begin
    if (Rst) begin // Reset
        // Clear stack memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        // Set stack pointer to 4 (indicating an empty buffer)
        SP <= 2'd4;
        // Set flags
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin // Enable
        if (!RW) begin // Write operation
            if (SP != 2'd0) begin // Buffer is not full
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                // Decrement stack pointer
                SP <= SP - 1'b1;
                // Update flags
                EMPTY <= (SP == 2'd4) ? 1'b1 : 1'b0;
                FULL <= (SP == 2'd0) ? 1'b1 : 1'b0;
            end
        end else begin // Read operation
            if (SP != 2'd4) begin // Buffer is not empty
                // Pop data from the stack
                dataOut <= stack_mem[SP];
                // Clear the corresponding stack memory
                stack_mem[SP] <= 4'd0;
                // Increment stack pointer
                SP <= SP + 1'b1;
                // Update flags
                EMPTY <= (SP == 2'd4) ? 1'b1 : 1'b0;
                FULL <= (SP == 2'd0) ? 1'b1 : 1'b0;
            end
        end
    end
end

endmodule