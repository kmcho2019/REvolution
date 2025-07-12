module LIFObuffer(
    input  [3:0] dataIn,
    input        RW,
    input        EN,
    input        Rst,
    input        Clk,
    output       EMPTY,
    output       FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [3:0];
reg [1:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        if (~RW) begin // Write operation
            if (SP != 2'd0) begin // Check if buffer is not full
                stack_mem[SP - 1] <= dataIn; // Push data onto the stack
                SP <= SP - 1; // Decrement stack pointer
            end
        end else begin // Read operation
            if (SP != 2'd4) begin // Check if buffer is not empty
                dataOut <= stack_mem[SP]; // Pop data from the stack
                stack_mem[SP] <= 4'd0; // Clear the popped memory location
                SP <= SP + 1; // Increment stack pointer
            end
        end
    end
end

// Update EMPTY and FULL flags based on stack pointer status
assign EMPTY = (SP == 2'd4);
assign FULL = (SP == 2'd0);

endmodule